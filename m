Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8131050583C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244701AbiDRN73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244653AbiDRN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3B32AE11;
        Mon, 18 Apr 2022 06:07:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE219CE10A6;
        Mon, 18 Apr 2022 13:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F8C385A1;
        Mon, 18 Apr 2022 13:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287231;
        bh=f7kEMIDSR5oPwl0HHAuS53E1cYfPrxskP80sIde1nkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoE9KEV6SVICCMOxJJQhVuMmiubdpHhYdlhtoIOGHM0er70fmQ2fELQNM4ZKOsYc0
         hDICEj3vpYzcuxfZ8HEjGaykwdLi+7HfpiSZ4xSpzNb/Q5P9HFAvnPnN9oqhRjQOQ5
         ajVs2m+29a1rXEz2XdcRqgv72hFnnqfGkxOsH4cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 080/218] ray_cs: Check ioremap return value
Date:   Mon, 18 Apr 2022 14:12:26 +0200
Message-Id: <20220418121201.895058948@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 7e4760713391ee46dc913194b33ae234389a174e ]

As the possible failure of the ioremap(), the 'local->sram' and other
two could be NULL.
Therefore it should be better to check it in order to avoid the later
dev_dbg.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211230022926.1846757-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ray_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index c78abfc7bd96..784063b1e60f 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -396,6 +396,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->sram = ioremap(link->resource[2]->start,
 			resource_size(link->resource[2]));
+	if (!local->sram)
+		goto failed;
 
 /*** Set up 16k window for shared memory (receive buffer) ***************/
 	link->resource[3]->flags |=
@@ -410,6 +412,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->rmem = ioremap(link->resource[3]->start,
 			resource_size(link->resource[3]));
+	if (!local->rmem)
+		goto failed;
 
 /*** Set up window for attribute memory ***********************************/
 	link->resource[4]->flags |=
@@ -424,6 +428,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->amem = ioremap(link->resource[4]->start,
 			resource_size(link->resource[4]));
+	if (!local->amem)
+		goto failed;
 
 	dev_dbg(&link->dev, "ray_config sram=%p\n", local->sram);
 	dev_dbg(&link->dev, "ray_config rmem=%p\n", local->rmem);
-- 
2.34.1



