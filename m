Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1BC60883A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiJVILw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiJVIKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB79357ED;
        Sat, 22 Oct 2022 00:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DD6460B4D;
        Sat, 22 Oct 2022 07:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79462C433C1;
        Sat, 22 Oct 2022 07:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425239;
        bh=PmD6zO5UnGlyOotddJ1nz8tCENZ3//IlzNov9zWnXmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYjnVHp6OxXoQBClsKC0ozdpLJmB1kHxnOGXspcGNq8qt4YvSCmxSxlPK2fSaA+VE
         kT20GbwFuD8hMcsPhysyWwS0FtnPsuTBbkkY8bF/ek7uDPS1QSZx4UOJP8JpVwvYDZ
         mFq+dfifLXsBObKKK5ecfhmKsTVwVL4G6VHNQo0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 437/717] ata: fix ata_id_has_dipm()
Date:   Sat, 22 Oct 2022 09:25:16 +0200
Message-Id: <20221022072517.703029680@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 4845443e0f08..e3050e153a71 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -574,6 +574,10 @@ struct ata_bmdma_prd {
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
@@ -597,17 +601,6 @@ static inline bool ata_id_has_hipm(const u16 *id)
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



