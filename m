Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0981A60A7B2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiJXMzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiJXMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:55:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0622DA88;
        Mon, 24 Oct 2022 05:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EB92612A0;
        Mon, 24 Oct 2022 12:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B472BC433C1;
        Mon, 24 Oct 2022 12:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612841;
        bh=0p4oaz3Q4XCXQAKF7VEiqqlMGv8Mr3Qg+CRmh0XHpks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uECIHQfmZDA09uL7oxOugupt1tK3T2d/w+L/77/FPJkNJ8QNXtLLMP7EUJGDGv1hv
         GUW2AOTWYx+6dx7R1Cm14nlQzR+77+vEf0DcckxR22mf1o3rwMnpddcb4dgoPlynNu
         Se6M2UlM9ZHb99x23FmaniV8/h9cmTzpX6Jqlf3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/229] ata: fix ata_id_has_dipm()
Date:   Mon, 24 Oct 2022 13:30:58 +0200
Message-Id: <20221024113003.511671935@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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

[ Upstream commit 630624cb1b5826d753ac8e01a0e42de43d66dedf ]

ACS-5 section
7.13.6.36 Word 78: Serial ATA features supported
states that:

If word 76 is not 0000h or FFFFh, word 78 reports the features supported
by the device. If this word is not supported, the word shall be cleared
to zero.

(This text also exists in really old ACS standards, e.g. ACS-3.)

The problem with ata_id_has_dipm() is that the while it performs a
check against 0 and 0xffff, it performs the check against
ATA_ID_FEATURE_SUPP (word 78), the same word where the feature bit
is stored.

Fix this by performing the check against ATA_ID_SATA_CAPABILITY
(word 76), like required by the spec. The feature bit check itself
is of course still performed against ATA_ID_FEATURE_SUPP (word 78).

Additionally, move the macro to the other ATA_ID_FEATURE_SUPP macros
(which already have this check), thus making it more likely that the
next ATA_ID_FEATURE_SUPP macro that is added will include this check.

Fixes: ca77329fb713 ("[libata] Link power management infrastructure")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ata.h | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index cfdaa08c45c9..981eb1cb7e49 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -589,6 +589,10 @@ struct ata_bmdma_prd {
 	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
 	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
 	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 7)))
+#define ata_id_has_dipm(id)	\
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 3)))
 #define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
@@ -612,17 +616,6 @@ static inline bool ata_id_has_hipm(const u16 *id)
 	return val & (1 << 9);
 }
 
-static inline bool ata_id_has_dipm(const u16 *id)
-{
-	u16 val = id[ATA_ID_FEATURE_SUPP];
-
-	if (val == 0 || val == 0xffff)
-		return false;
-
-	return val & (1 << 3);
-}
-
-
 static inline bool ata_id_has_fua(const u16 *id)
 {
 	if ((id[ATA_ID_CFSSE] & 0xC000) != 0x4000)
-- 
2.35.1



