Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D026560A304
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiJXLuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiJXLsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC9075FD7;
        Mon, 24 Oct 2022 04:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6F1A61298;
        Mon, 24 Oct 2022 11:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D63C433D6;
        Mon, 24 Oct 2022 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611773;
        bh=6b9qQMB8K1T9HlZwNftxCzmN5s2QJzdCsETri9vqOrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s44jVeZYHYkPpGLrHk9sUhELFEgG/BhPzgZN7jTFTPKLVX+Q40+v8Pat99QaS18e+
         MHQZNz5w8PdP2D1qjfMR9R5S3eUXrjKQvm+Rk9sL9qOQNe+bjOHz4SCIdK2kpPH9S/
         AlQRHdVecXsXdLpyRh8496SYtmnpF2mpAHZFF7NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/159] ata: fix ata_id_has_devslp()
Date:   Mon, 24 Oct 2022 13:30:59 +0200
Message-Id: <20221024112953.276522056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit 9c6e09a434e1317e09b78b3b69cd384022ec9a03 ]

ACS-5 section
7.13.6.36 Word 78: Serial ATA features supported
states that:

If word 76 is not 0000h or FFFFh, word 78 reports the features supported
by the device. If this word is not supported, the word shall be cleared
to zero.

(This text also exists in really old ACS standards, e.g. ACS-3.)

Additionally, move the macro to the other ATA_ID_FEATURE_SUPP macros
(which already have this check), thus making it more likely that the
next ATA_ID_FEATURE_SUPP macro that is added will include this check.

Fixes: 65fe1f0f66a5 ("ahci: implement aggressive SATA device sleep support")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ata.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8e5e7bf4a37f..315a7eaba655 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -572,6 +572,10 @@ struct ata_bmdma_prd {
 	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
 	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
 	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 2)))
+#define ata_id_has_devslp(id)	\
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 8)))
 #define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
@@ -584,7 +588,6 @@ struct ata_bmdma_prd {
 
 #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
 #define ata_id_has_da(id)	((id)[ATA_ID_SATA_CAPABILITY_2] & (1 << 4))
-#define ata_id_has_devslp(id)	((id)[ATA_ID_FEATURE_SUPP] & (1 << 8))
 #define ata_id_has_ncq_autosense(id) \
 				((id)[ATA_ID_FEATURE_SUPP] & (1 << 7))
 
-- 
2.35.1



