Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F77C4BDD7D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbiBUJfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:35:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350520AbiBUJfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:35:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F140B2AE3D;
        Mon, 21 Feb 2022 01:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C89060EB5;
        Mon, 21 Feb 2022 09:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CBFC340E9;
        Mon, 21 Feb 2022 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434882;
        bh=myw3QrAMQ7VVVXV9oni2wkVFSEnyKFd6dj17fy2ABdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knsp71VkOVBxdDWs1n8BuWHR0i/BeXBvB3DQ8RZ3B5K/Rt/dEDx/PNuCk7pcDRogt
         6WTBd5xRgHKNiT1i3LZYGW0tfsArGRIplWjIg6yX/UajPVh7oqn083p5xNIDVTmjDs
         U9XlPr6FmTZE+9SglLYkkhdClt/whPJhcM7zKo+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/196] ata: libata-core: Disable TRIM on M88V29
Date:   Mon, 21 Feb 2022 09:49:57 +0100
Message-Id: <20220221084936.475426026@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 4d848cfc406fe..24b67d78cb83d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4014,6 +4014,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* devices that don't properly handle TRIM commands */
 	{ "SuperSSpeed S238*",		NULL,	ATA_HORKAGE_NOTRIM, },
+	{ "M88V29*",			NULL,	ATA_HORKAGE_NOTRIM, },
 
 	/*
 	 * As defined, the DRAT (Deterministic Read After Trim) and RZAT
-- 
2.34.1



