Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F7A417384
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbhIXM5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344800AbhIXMzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 099E461107;
        Fri, 24 Sep 2021 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487862;
        bh=1E3rpQWxKiZTxXGpPvptV8BtqPwPaouT2/KeUgxNOto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNouj73WXEdUn4U+y8tLKdy1s6p/V5uI33dWP8yDkBWgNpq4r7lKCkvehugxHHXrd
         T7Q6i3xJ2IKPKoreuTehRaMZV8p0S7D7LdGp13B9tklmJ4mqR6Z2ey9xBQv1e5cxua
         VWI5A2TGcmgd49E1zt2Auiy116gfMSr4Llt71pV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.4 09/50] ARM: Qualify enabling of swiotlb_init()
Date:   Fri, 24 Sep 2021 14:43:58 +0200
Message-Id: <20210924124332.547892561@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit fcf044891c84e38fc90eb736b818781bccf94e38 upstream.

We do not need a SWIOTLB unless we have DRAM that is addressable beyond
the arm_dma_limit. Compare max_pfn with arm_dma_pfn_limit to determine
whether we do need a SWIOTLB to be initialized.

Fixes: ad3c7b18c5b3 ("arm: use swiotlb for bounce buffering on LPAE configs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/init.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -469,7 +469,11 @@ static void __init free_highpages(void)
 void __init mem_init(void)
 {
 #ifdef CONFIG_ARM_LPAE
-	swiotlb_init(1);
+	if (swiotlb_force == SWIOTLB_FORCE ||
+	    max_pfn > arm_dma_pfn_limit)
+		swiotlb_init(1);
+	else
+		swiotlb_force = SWIOTLB_NO_FORCE;
 #endif
 
 	set_max_mapnr(pfn_to_page(max_pfn) - mem_map);


