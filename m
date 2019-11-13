Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89314FA3C9
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfKMB6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbfKMB6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6979222D4;
        Wed, 13 Nov 2019 01:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610301;
        bh=YM+20L3XfJDfQla675w1xo0yGmW/B4bzJN2PdZ3ouaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KD7tweOMDaV+O9vgcUjwbm0pm7uRK1/i1lWDoAqgcgBHwy8V8MDgS387/eSp8pns
         GkzSJG24WgQTQsN1aOd6LMITexG/ub72PqUk0ZELVAuOmPrbEFcLXHjUYY707XsjCr
         KSYbISU++79U3E6Did7/GzuO9wTebE5cyOPyPX1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lianbo Jiang <lijiang@redhat.com>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kexec@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, dan.j.williams@intel.com,
        bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de,
        brijesh.singh@amd.com, dyoung@redhat.com, bhe@redhat.com,
        jroedel@suse.de, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 072/115] kexec: Allocate decrypted control pages for kdump if SME is enabled
Date:   Tue, 12 Nov 2019 20:55:39 -0500
Message-Id: <20191113015622.11592-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lianbo Jiang <lijiang@redhat.com>

[ Upstream commit 9cf38d5559e813cccdba8b44c82cc46ba48d0896 ]

When SME is enabled in the first kernel, it needs to allocate decrypted
pages for kdump because when the kdump kernel boots, these pages need to
be accessed decrypted in the initial boot stage, before SME is enabled.

 [ bp: clean up text. ]

Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kexec@lists.infradead.org
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: akpm@linux-foundation.org
Cc: dan.j.williams@intel.com
Cc: bhelgaas@google.com
Cc: baiyaowei@cmss.chinamobile.com
Cc: tiwai@suse.de
Cc: brijesh.singh@amd.com
Cc: dyoung@redhat.com
Cc: bhe@redhat.com
Cc: jroedel@suse.de
Link: https://lkml.kernel.org/r/20180930031033.22110-3-lijiang@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 8f15665ab6167..27cf24e285e0c 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -473,6 +473,10 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 		}
 	}
 
+	/* Ensure that these pages are decrypted if SME is enabled. */
+	if (pages)
+		arch_kexec_post_alloc_pages(page_address(pages), 1 << order, 0);
+
 	return pages;
 }
 
@@ -867,6 +871,7 @@ static int kimage_load_crash_segment(struct kimage *image,
 			result  = -ENOMEM;
 			goto out;
 		}
+		arch_kexec_post_alloc_pages(page_address(page), 1, 0);
 		ptr = kmap(page);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = min_t(size_t, mbytes,
@@ -884,6 +889,7 @@ static int kimage_load_crash_segment(struct kimage *image,
 			result = copy_from_user(ptr, buf, uchunk);
 		kexec_flush_icache_page(page);
 		kunmap(page);
+		arch_kexec_pre_free_pages(page_address(page), 1);
 		if (result) {
 			result = -EFAULT;
 			goto out;
-- 
2.20.1

