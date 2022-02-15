Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137C04B733E
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbiBOPgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:36:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240953AbiBOPf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF6D89CED;
        Tue, 15 Feb 2022 07:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AAF461692;
        Tue, 15 Feb 2022 15:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA85CC340ED;
        Tue, 15 Feb 2022 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939093;
        bh=5C8MD+mk+Eb5UUBsFV2o0TrobpgLPD9Gi8Eu2lLIYVk=;
        h=From:To:Cc:Subject:Date:From;
        b=AX8yMTiVq+VrEIQEQ5J3zillLbqvi5yt9t8N60VeifuCm319d7H0ATs1wpIXnVwCi
         2tQse2hK2vTv9DDdTpDELUb+lIwHE0RXaSrwkoU9GfWQ6GbN00YF0/lls0cmaDZKM5
         Ab8IMGO81QwP3BMB4OIjdyDiVaVw1BffKmqeM5rybH0/ok5K0+5UCSCPREXdbQ3FoB
         qKVAadRWZJdnbWZGIwFXnRYFd4OiDsOPaOjv8PATS1eYmDsEjv1mL7KCGjCKaRGAsq
         wKP1BYVH/WpNAOQV5X7dq/IG+SoAi18xNk4C6VJUnAXwjoBC6j7Qm3KszFyeDVPUCN
         Oh0KovsAsOX4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/3] ata: libata-core: Disable TRIM on M88V29
Date:   Tue, 15 Feb 2022 10:31:28 -0500
Message-Id: <20220215153131.582008-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zoltán Böszörményi <zboszor@gmail.com>

[ Upstream commit c8ea23d5fa59f28302d4e3370c75d9c308e64410 ]

This device is a CF card, or possibly an SSD in CF form factor.
It supports NCQ and high speed DMA.

While it also advertises TRIM support, I/O errors are reported
when the discard mount option fstrim is used. TRIM also fails
when disabling NCQ and not just as an NCQ command.

TRIM must be disabled for this device.

Signed-off-by: Zoltán Böszörményi <zboszor@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a92cbe1aa72a2..35db918a1de56 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4486,6 +4486,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* devices that don't properly handle TRIM commands */
 	{ "SuperSSpeed S238*",		NULL,	ATA_HORKAGE_NOTRIM, },
+	{ "M88V29*",			NULL,	ATA_HORKAGE_NOTRIM, },
 
 	/*
 	 * As defined, the DRAT (Deterministic Read After Trim) and RZAT
-- 
2.34.1

