Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79E3106F04
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfKVKzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbfKVKzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A811E2071F;
        Fri, 22 Nov 2019 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420121;
        bh=YM+20L3XfJDfQla675w1xo0yGmW/B4bzJN2PdZ3ouaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9ix6s8f3NqbyS7S4l6gKFqzAlZ4ZIDuiI/5TKFFJY8aDb5ZD2flc5RO2/yW08Mop
         e6RMYmaPEIra9C9q8+4W/hRJ8XkxpYtTgU1/1YorMuMOGT5UywgVqQcQo9Lcwyda53
         g8/dPLwYxv1jtNbkj7S/cAFHsjvX1BdIJ6SAatTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lianbo Jiang <lijiang@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kexec@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, dan.j.williams@intel.com,
        bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de,
        brijesh.singh@amd.com, dyoung@redhat.com, bhe@redhat.com,
        jroedel@suse.de, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 079/122] kexec: Allocate decrypted control pages for kdump if SME is enabled
Date:   Fri, 22 Nov 2019 11:28:52 +0100
Message-Id: <20191122100819.526924385@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



