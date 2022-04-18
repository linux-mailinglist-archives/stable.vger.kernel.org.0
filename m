Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1334505529
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241741AbiDRNWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243464AbiDRNUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:20:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23929D67;
        Mon, 18 Apr 2022 05:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BA12B80EC0;
        Mon, 18 Apr 2022 12:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D544AC385A7;
        Mon, 18 Apr 2022 12:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286325;
        bh=1hBGvoDUQ8oK2e2NrWc1/JduXPO8/pqmlEm+Me1KFmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEwhY/DWQeQZUQtY+GLrDEQ9bK0PwAmmXFqDFH4zvQZA1V3ihK8fgkYeggHoKhw1q
         2MCoCa7WDDYyTafvxDNJPvJLinrW/y3snlAnGLVFya3xCxYiPzRICy7qYBgHeFpsHo
         vwO2qcSFxeOp/e42RWQ0ZqlicKY2gN6fa7eq2+6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/284] ray_cs: Check ioremap return value
Date:   Mon, 18 Apr 2022 14:11:21 +0200
Message-Id: <20220418121213.614449852@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
index 170cd504e8ff..1ee150563260 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -395,6 +395,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->sram = ioremap(link->resource[2]->start,
 			resource_size(link->resource[2]));
+	if (!local->sram)
+		goto failed;
 
 /*** Set up 16k window for shared memory (receive buffer) ***************/
 	link->resource[3]->flags |=
@@ -409,6 +411,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->rmem = ioremap(link->resource[3]->start,
 			resource_size(link->resource[3]));
+	if (!local->rmem)
+		goto failed;
 
 /*** Set up window for attribute memory ***********************************/
 	link->resource[4]->flags |=
@@ -423,6 +427,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->amem = ioremap(link->resource[4]->start,
 			resource_size(link->resource[4]));
+	if (!local->amem)
+		goto failed;
 
 	dev_dbg(&link->dev, "ray_config sram=%p\n", local->sram);
 	dev_dbg(&link->dev, "ray_config rmem=%p\n", local->rmem);
-- 
2.34.1



