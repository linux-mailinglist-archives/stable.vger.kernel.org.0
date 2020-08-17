Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098D4247002
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390089AbgHQR6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388540AbgHQQKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6335B20772;
        Mon, 17 Aug 2020 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680599;
        bh=uNGWZjCsg64ckoUhe0XxFhNdO/u7Unjei4kpB/FWVdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbUSFgS8pm4ROKF+FimIsHZB6mopblhf7iyfVNVWLpc/hK1FBtR3p9cg03wzAW9EA
         fDUMe2WpNdLKKKnQk4FZjMDH26txL/t3PxgKbgpKXBIEFMKbl0TMl/GM//Cpcht/BF
         EhgakJzUPguPB8USt2xra3Jz0VZj6tBgw+LfLU4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 251/270] parisc: mask out enable and reserved bits from sba imask
Date:   Mon, 17 Aug 2020 17:17:32 +0200
Message-Id: <20200817143808.328815013@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

commit 5b24993c21cbf2de11aff077a48c5cb0505a0450 upstream.

When using kexec the SBA IOMMU IBASE might still have the RE
bit set. This triggers a WARN_ON when trying to write back the
IBASE register later, and it also makes some mask calculations fail.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parisc/sba_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1270,7 +1270,7 @@ sba_ioc_init_pluto(struct parisc_device
 	** (one that doesn't overlap memory or LMMIO space) in the
 	** IBASE and IMASK registers.
 	*/
-	ioc->ibase = READ_REG(ioc->ioc_hpa + IOC_IBASE);
+	ioc->ibase = READ_REG(ioc->ioc_hpa + IOC_IBASE) & ~0x1fffffULL;
 	iova_space_size = ~(READ_REG(ioc->ioc_hpa + IOC_IMASK) & 0xFFFFFFFFUL) + 1;
 
 	if ((ioc->ibase < 0xfed00000UL) && ((ioc->ibase + iova_space_size) > 0xfee00000UL)) {


