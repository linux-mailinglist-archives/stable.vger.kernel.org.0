Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427444B72B7
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiBOPgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:36:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240826AbiBOPfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E2C220C9;
        Tue, 15 Feb 2022 07:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2B3B6167C;
        Tue, 15 Feb 2022 15:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949AEC36AE2;
        Tue, 15 Feb 2022 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939086;
        bh=4lO6JmZ9MvQL5yGg6vWszWkyE8N1+IVs3euL5JN/hjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQZkRNyf/7sia0Hc340zSVZUVj9yfGqamme0kmMdBtgP6f7pywUYjNvWwS/nKn4yg
         R/3M250hYwZAKNPKVwOn0cE4jSAOhO6s+BDSDtnG1h2vwPpce331z6WWbBN+J0UPag
         sKzxEFsrq0IUIpWUjEPBwj0nwtx6HQAESC8iT7PI7cgJtQaGsKiEkiPXcu39QeuQYO
         Di9bQafBQm7fYhooIg2eInPoi0/3Uq0ytnCKb4s06nV2o7RIgsHqiNRffrlJdKR6dn
         TDNWgJTIcjBIQIsWWGhkEik8jW1djStZ8fI33wnpeSl5daOhTdpWp7kUzeayzy+kXv
         48G6pXb7HsAtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/5] ata: libata-core: Disable TRIM on M88V29
Date:   Tue, 15 Feb 2022 10:31:19 -0500
Message-Id: <20220215153122.581930-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153122.581930-1-sashal@kernel.org>
References: <20220215153122.581930-1-sashal@kernel.org>
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
index 8ec71243cdcca..791374199e227 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4603,6 +4603,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* devices that don't properly handle TRIM commands */
 	{ "SuperSSpeed S238*",		NULL,	ATA_HORKAGE_NOTRIM, },
+	{ "M88V29*",			NULL,	ATA_HORKAGE_NOTRIM, },
 
 	/*
 	 * As defined, the DRAT (Deterministic Read After Trim) and RZAT
-- 
2.34.1

