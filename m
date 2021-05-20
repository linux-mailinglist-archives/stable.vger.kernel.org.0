Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CD538A9B1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhETLFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239282AbhETLDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C912D61924;
        Thu, 20 May 2021 10:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505060;
        bh=U5N/GdyTV5zFPWNj6RxCgq2re3ReJcMbI8cfl+nBixM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqLjG/zUzkO9dsZBH/fxs/oMB+pflCscZUH/S60H2SmfdztIrov+RIMJ5s912cdRb
         Ckm5IYWa16yE8vCsC5tzmBiUII7YWg0w1x/S4A4+Syr/oo1AZ355br1hAcLVMQA4Zq
         SrdYc0eM1Ba/mRXTM5X0UyWo2CrSKTkCrkIQ1WKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 204/240] kernel: kexec_file: fix error return code of kexec_calculate_store_digests()
Date:   Thu, 20 May 2021 11:23:16 +0200
Message-Id: <20210520092115.509485964@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 31d82c2c787d5cf65fedd35ebbc0c1bd95c1a679 ]

When vzalloc() returns NULL to sha_regions, no error return code of
kexec_calculate_store_digests() is assigned.  To fix this bug, ret is
assigned with -ENOMEM in this case.

Link: https://lkml.kernel.org/r/20210309083904.24321-1-baijiaju1990@gmail.com
Fixes: a43cac0d9dc2 ("kexec: split kexec_file syscall code to kexec_file.c")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 037c321c5618..2edaed6803ff 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -528,8 +528,10 @@ static int kexec_calculate_store_digests(struct kimage *image)
 
 	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
 	sha_regions = vzalloc(sha_region_sz);
-	if (!sha_regions)
+	if (!sha_regions) {
+		ret = -ENOMEM;
 		goto out_free_desc;
+	}
 
 	desc->tfm   = tfm;
 	desc->flags = 0;
-- 
2.30.2



