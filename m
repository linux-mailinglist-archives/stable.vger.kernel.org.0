Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6050524B795
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbgHTK7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbgHTKNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:13:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D45A20738;
        Thu, 20 Aug 2020 10:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918412;
        bh=nxbijIe3mjlBYbtASARKH08UZo8+8GTitovu0fEMvmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWEmPXLpqW5u8v2mDYOMH5OdmmNGgtQzT74h4/w3VeRElkrnKCGnp1z3Q7+IsdQXj
         F8JWgG/kiTjNoycm/hEn1L5r2sN7S5FP/txgw/6BhCa6aXqe4eOTomzmDmJygR4kqQ
         m+P1Igi3oAN8jyo90SLM/KgKmXxCKnjwLhYJbbR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 161/228] parisc: mask out enable and reserved bits from sba imask
Date:   Thu, 20 Aug 2020 11:22:16 +0200
Message-Id: <20200820091615.623702917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
@@ -1291,7 +1291,7 @@ sba_ioc_init_pluto(struct parisc_device
 	** (one that doesn't overlap memory or LMMIO space) in the
 	** IBASE and IMASK registers.
 	*/
-	ioc->ibase = READ_REG(ioc->ioc_hpa + IOC_IBASE);
+	ioc->ibase = READ_REG(ioc->ioc_hpa + IOC_IBASE) & ~0x1fffffULL;
 	iova_space_size = ~(READ_REG(ioc->ioc_hpa + IOC_IMASK) & 0xFFFFFFFFUL) + 1;
 
 	if ((ioc->ibase < 0xfed00000UL) && ((ioc->ibase + iova_space_size) > 0xfee00000UL)) {


