Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36234F2834
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiDEILV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbiDEIFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:05:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006B16663D;
        Tue,  5 Apr 2022 01:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 947E9616DF;
        Tue,  5 Apr 2022 08:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D42C340EE;
        Tue,  5 Apr 2022 08:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145673;
        bh=tq/To8jVh1mvFDi3w64M21F7yGLggTqHun//0zGuXVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VefRi1yLjLbP1HLbwFygZWmQvJprmmsqPazL24WlD/rlisoa33QLJJQqUIJy2LNM
         UNq2Xy6J3yMcHWpBWTFbW/CY2gtT7ap3Y/+XW5qxWkxmfkzn3850xAmNdVtgwcVL0e
         lthLsGDVhIcKFFbvmR+Jd+9OCI3z2HNA+EJ9ZIHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0488/1126] ray_cs: Check ioremap return value
Date:   Tue,  5 Apr 2022 09:20:35 +0200
Message-Id: <20220405070421.951684822@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 2987ad9271f6..87e98ab068ed 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -382,6 +382,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->sram = ioremap(link->resource[2]->start,
 			resource_size(link->resource[2]));
+	if (!local->sram)
+		goto failed;
 
 /*** Set up 16k window for shared memory (receive buffer) ***************/
 	link->resource[3]->flags |=
@@ -396,6 +398,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->rmem = ioremap(link->resource[3]->start,
 			resource_size(link->resource[3]));
+	if (!local->rmem)
+		goto failed;
 
 /*** Set up window for attribute memory ***********************************/
 	link->resource[4]->flags |=
@@ -410,6 +414,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->amem = ioremap(link->resource[4]->start,
 			resource_size(link->resource[4]));
+	if (!local->amem)
+		goto failed;
 
 	dev_dbg(&link->dev, "ray_config sram=%p\n", local->sram);
 	dev_dbg(&link->dev, "ray_config rmem=%p\n", local->rmem);
-- 
2.34.1



