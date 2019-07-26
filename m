Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE1476E05
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfGZP2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388520AbfGZP2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 153D422BF5;
        Fri, 26 Jul 2019 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154913;
        bh=FSxcoe0vev0viFEPTvMHHo+z70LrRcb4sZS5cRzAfLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qI7nXZdQCjGHCnXguEn/uPKfsgy7qmkHlJmhqFYbumCoXflM/1/EsKwWtKLAUPHOd
         DTkHOTreaAM8PUebMYWgtOvt1ghmWp2nMvK63CeYI+uj5gP9CbPjhJUNtRL6aUkUVg
         ZEcv9JdG3XblVZefAHRzQyrfNMMm/U05IqKj/Q6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 43/66] bnxt_en: Fix VNIC accounting when enabling aRFS on 57500 chips.
Date:   Fri, 26 Jul 2019 17:24:42 +0200
Message-Id: <20190726152306.644530029@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 9b3d15e6b05e0b916be5fbd915f90300a403098b ]

Unlike legacy chips, 57500 chips don't need additional VNIC resources
for aRFS/ntuple.  Fix the code accordingly so that we don't reserve
and allocate additional VNICs on 57500 chips.  Without this patch,
the driver is failing to initialize when it tries to allocate extra
VNICs.

Fixes: ac33906c67e2 ("bnxt_en: Add support for aRFS on 57500 chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3022,7 +3022,7 @@ static int bnxt_alloc_vnics(struct bnxt
 	int num_vnics = 1;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (bp->flags & BNXT_FLAG_RFS)
+	if ((bp->flags & (BNXT_FLAG_RFS | BNXT_FLAG_CHIP_P5)) == BNXT_FLAG_RFS)
 		num_vnics += bp->rx_nr_rings;
 #endif
 
@@ -7133,6 +7133,9 @@ static int bnxt_alloc_rfs_vnics(struct b
 #ifdef CONFIG_RFS_ACCEL
 	int i, rc = 0;
 
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return 0;
+
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_vnic_info *vnic;
 		u16 vnic_id = i + 1;
@@ -9592,7 +9595,7 @@ int bnxt_check_rings(struct bnxt *bp, in
 		return -ENOMEM;
 
 	vnics = 1;
-	if (bp->flags & BNXT_FLAG_RFS)
+	if ((bp->flags & (BNXT_FLAG_RFS | BNXT_FLAG_CHIP_P5)) == BNXT_FLAG_RFS)
 		vnics += rx_rings;
 
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)


