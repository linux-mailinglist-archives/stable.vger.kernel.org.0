Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D1455C562
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbiF0LvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237839AbiF0LtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:49:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21778F;
        Mon, 27 Jun 2022 04:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81ED661240;
        Mon, 27 Jun 2022 11:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934C6C3411D;
        Mon, 27 Jun 2022 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330186;
        bh=nCDHVYBa6tLgsI2FQekanx0TPVqlYvk8XwJJwY5wi4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6v16WLwic0yAHa/9ZaLRJ0Z47UyubIk3TDnR4eo7JaCg7KhLNB7Xa+2xxgZQkSra
         ySZLc8mQCoGlcicbBxIAJjI/C2lSVSI8GRx8q437ab2b49HFWazMyPPx+up1H4LMK2
         GPsd8mkWKbizv2mP4yF0YSDHUbtFAY2b8iPB+BzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 113/181] s390/crash: add missing iterator advance in copy_oldmem_page()
Date:   Mon, 27 Jun 2022 13:21:26 +0200
Message-Id: <20220627111947.974596667@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit cc02e6e21aa5f2ac0defe8c15e5a9d024da6e73d ]

In case old memory was successfully copied the passed iterator
should be advanced as well. Currently copy_oldmem_page() is
always called with single-segment iterator. Should that ever
change - copy_oldmem_user and copy_oldmem_kernel() functions
would need a rework to deal with multi-segment iterators.

Fixes: 5d8de293c224 ("vmcore: convert copy_oldmem_page() to take an iov_iter")
Reviewed-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/crash_dump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index a2c1c55daec0..2534a31d2550 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -219,6 +219,11 @@ ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
 	unsigned long src;
 	int rc;
 
+	if (!(iter_is_iovec(iter) || iov_iter_is_kvec(iter)))
+		return -EINVAL;
+	/* Multi-segment iterators are not supported */
+	if (iter->nr_segs > 1)
+		return -EINVAL;
 	if (!csize)
 		return 0;
 	src = pfn_to_phys(pfn) + offset;
@@ -228,6 +233,8 @@ ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn, size_t csize,
 		rc = copy_oldmem_user(iter->iov->iov_base, src, csize);
 	else
 		rc = copy_oldmem_kernel(iter->kvec->iov_base, src, csize);
+	if (!rc)
+		iov_iter_advance(iter, csize);
 	return rc;
 }
 
-- 
2.35.1



