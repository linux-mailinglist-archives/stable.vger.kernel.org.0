Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B814B71FF
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbiBOPgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:36:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240555AbiBOPf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E17FB820B;
        Tue, 15 Feb 2022 07:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8603B81AEC;
        Tue, 15 Feb 2022 15:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767AC340F1;
        Tue, 15 Feb 2022 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939076;
        bh=fkywtcnuRfM9nJSw5O0w6qFGqmj7tRXqEy/urhu+8K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j66cyEsf2dHa6aK8g6nxf7vMCbGbCjGa8BupcdUak+nXDqQhT2L9xdRa8Ifvj79O0
         /w3zlXteDoT5M6R7+wwGM+BWjCuL0w4CkUWwiCM+Ydf9LhUbvLpmwRv4Hxx6VeIdG7
         7VcoghS+8azXkXCOJ/rQwcpiNeXyt9dv53Kfh7l67qdAELDmHo4Bv2+lpf2GzbEr/c
         +/TqJeo8YenrXUxeMQ9Yuhdjs24TjxrEmmxVuqPu+XncUQOvOr8u/6YUNiWdWhz1nX
         ObX87DyVtqqSClHEN+6Tq283sh5PGYAkGooYc2SVszxv9qoaicrGyO+oHxZ7vUjfY5
         cULL7Rn/M1efw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/11] ata: libata-core: Disable TRIM on M88V29
Date:   Tue, 15 Feb 2022 10:31:00 -0500
Message-Id: <20220215153104.581786-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153104.581786-1-sashal@kernel.org>
References: <20220215153104.581786-1-sashal@kernel.org>
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
index 46eacba2613b8..33d3728f36222 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4613,6 +4613,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* devices that don't properly handle TRIM commands */
 	{ "SuperSSpeed S238*",		NULL,	ATA_HORKAGE_NOTRIM, },
+	{ "M88V29*",			NULL,	ATA_HORKAGE_NOTRIM, },
 
 	/*
 	 * As defined, the DRAT (Deterministic Read After Trim) and RZAT
-- 
2.34.1

