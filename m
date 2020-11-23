Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC12C06CB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbgKWMee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731382AbgKWMed (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E117720721;
        Mon, 23 Nov 2020 12:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134873;
        bh=l/knj+j0jRFR8PxDq7BeTfiWtHE/BMFogcZAejeVNmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBYuzGece+PQ33TwPNI4QQn/MGH9hbn/LPKdAEtfSj6cjTdLYsmwfi8kdDfdx9+br
         Rzqsni9uIGseAA4z/1iM69CAZ9+mrezRshJKCVNdLk60geZk7rzWdCw54Rh9l0J8we
         DCr63sl0R2N/S9l8YytIKyTu9QBwrZaO83o992VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 003/158] bnxt_en: read EEPROM A2h address using page 0
Date:   Mon, 23 Nov 2020 13:20:31 +0100
Message-Id: <20201123121820.116565138@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit 4260330b32b14330cfe427d568ac5f5b29b5be3d ]

The module eeprom address range returned by bnxt_get_module_eeprom()
should be 256 bytes of A0h address space, the lower half of the A2h
address space, and page 0 for the upper half of the A2h address space.

Fix the firmware call by passing page_number 0 for the A2h slave address
space.

Fixes: 42ee18fe4ca2 ("bnxt_en: Add Support for ETHTOOL_GMODULEINFO and ETHTOOL_GMODULEEEPRO")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2584,7 +2584,7 @@ static int bnxt_get_module_eeprom(struct
 	/* Read A2 portion of the EEPROM */
 	if (length) {
 		start -= ETH_MODULE_SFF_8436_LEN;
-		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A2, 1,
+		rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A2, 0,
 						      start, length, data);
 	}
 	return rc;


