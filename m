Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0E41CAB1F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEHMkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgEHMkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ACBD24968;
        Fri,  8 May 2020 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941605;
        bh=fhGKW3nCmRVgvhIPG6D5GR+JcvETF0h42Ray+1kxgHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlqNhel4nYJGHAz84jB8TiaUDzJHULxFh5exFIQNWztprJ58nSJnJv70iMHNlNOOp
         YcXXq4+sZZHyiD7pMPtFFOfJICmuyKekAn4BjWbqW/kVf0r8N1ICcFsAEassyNbwat
         MUENr2ENSb7KJWxxdXZayYYWET/cM9EPpmmvlQ2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 4.4 098/312] mtd: nand: fix ONFI parameter page layout
Date:   Fri,  8 May 2020 14:31:29 +0200
Message-Id: <20200508123131.421752932@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

commit de64aa9ec129ba627634088f662a4d09e356ddb6 upstream.

src_ssync_features field is only 1 byte large, and the 4th reserved area
is actually 8 bytes large.

Fixes: d1e1f4e42b5 ("mtd: nand: add support for reading ONFI parameters from NAND device")
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mtd/nand.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -276,7 +276,7 @@ struct nand_onfi_params {
 	__le16 t_r;
 	__le16 t_ccs;
 	__le16 src_sync_timing_mode;
-	__le16 src_ssync_features;
+	u8 src_ssync_features;
 	__le16 clk_pin_capacitance_typ;
 	__le16 io_pin_capacitance_typ;
 	__le16 input_pin_capacitance_typ;
@@ -284,7 +284,7 @@ struct nand_onfi_params {
 	u8 driver_strength_support;
 	__le16 t_int_r;
 	__le16 t_ald;
-	u8 reserved4[7];
+	u8 reserved4[8];
 
 	/* vendor */
 	__le16 vendor_revision;


