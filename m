Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31B560A605
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiJXMbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiJXM3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E3688A2B;
        Mon, 24 Oct 2022 05:03:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83B0BB81212;
        Mon, 24 Oct 2022 12:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5CBC4314D;
        Mon, 24 Oct 2022 12:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612833;
        bh=mT8ZRVYxjrruZWUmwxV+YGPFhC0ZsyPOFU+ocTtLHQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGQemGjmp5UmjuitKDqemdIjo6rtLMB5pSVmThu/fvwuzj5te6wzbacCmZ9AD/Egv
         3NsZTyB4XSiRDOyKuAJAbleyw2uAvJqbgoZ6I9jtlSL75K77NiqMCun4GN38qQcvov
         06wGoWnn6HU325eW2BY+tXygjrxzGprgS1yz+TG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/229] ata: fix ata_id_sense_reporting_enabled() and ata_id_has_sense_reporting()
Date:   Mon, 24 Oct 2022 13:30:55 +0200
Message-Id: <20221024113003.410828422@linuxfoundation.org>
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

[ Upstream commit 690aa8c3ae308bc696ec8b1b357b995193927083 ]

ACS-5 section
7.13.6.41 Words 85..87, 120: Commands and feature sets supported or enabled
states that:

If bit 15 of word 86 is set to one, bit 14 of word 119 is set to one,
and bit 15 of word 119 is cleared to zero, then word 119 is valid.

If bit 15 of word 86 is set to one, bit 14 of word 120 is set to one,
and bit 15 of word 120 is cleared to zero, then word 120 is valid.

(This text also exists in really old ACS standards, e.g. ACS-3.)

Currently, ata_id_sense_reporting_enabled() and
ata_id_has_sense_reporting() both check bit 15 of word 86,
but neither of them check that bit 14 of word 119 is set to one,
or that bit 15 of word 119 is cleared to zero.

Additionally, make ata_id_sense_reporting_enabled() return false
if !ata_id_has_sense_reporting(), similar to how e.g.
ata_id_flush_ext_enabled() returns false if !ata_id_has_flush_ext().

Fixes: e87fd28cf9a2 ("libata: Implement support for sense data reporting")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ata.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 40d150ad7e07..351e58312e7d 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -786,16 +786,21 @@ static inline bool ata_id_has_read_log_dma_ext(const u16 *id)
 
 static inline bool ata_id_has_sense_reporting(const u16 *id)
 {
-	if (!(id[ATA_ID_CFS_ENABLE_2] & (1 << 15)))
+	if (!(id[ATA_ID_CFS_ENABLE_2] & BIT(15)))
+		return false;
+	if ((id[ATA_ID_COMMAND_SET_3] & (BIT(15) | BIT(14))) != BIT(14))
 		return false;
-	return id[ATA_ID_COMMAND_SET_3] & (1 << 6);
+	return id[ATA_ID_COMMAND_SET_3] & BIT(6);
 }
 
 static inline bool ata_id_sense_reporting_enabled(const u16 *id)
 {
-	if (!(id[ATA_ID_CFS_ENABLE_2] & (1 << 15)))
+	if (!ata_id_has_sense_reporting(id))
+		return false;
+	/* ata_id_has_sense_reporting() == true, word 86 must have bit 15 set */
+	if ((id[ATA_ID_COMMAND_SET_4] & (BIT(15) | BIT(14))) != BIT(14))
 		return false;
-	return id[ATA_ID_COMMAND_SET_4] & (1 << 6);
+	return id[ATA_ID_COMMAND_SET_4] & BIT(6);
 }
 
 /**
-- 
2.35.1



