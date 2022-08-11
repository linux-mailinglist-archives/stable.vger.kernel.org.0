Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755235901B8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbiHKP5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiHKPzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:55:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A65225CA;
        Thu, 11 Aug 2022 08:46:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9921B82160;
        Thu, 11 Aug 2022 15:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC4FC433D7;
        Thu, 11 Aug 2022 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232772;
        bh=aVDfoQXhnCJz3FkHiF1y08f1OF1Zx0Iw4ujPQBH0Bik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBJofwpvqDbrPO3QTuvpCkIw4cbqP1jDBXvfu560pNgic4pwApUuBTdqKRd8zz475
         LytJXfQ7BfO5vQOORCh4H4UPoUWtnf6BT4hVRG7k++APLzFxuJJuXyZhAfdDN8QHzI
         Aza93GPqYdmCNIvT/mmgsCzELwexL3BXlDRcakY6rw2AQJpeJevMtL/sCjYU21odjQ
         XXHdrYo/mI5JSe/pZGQEXIx2LS0Z0Fq35OUDKzZCyjrfogWZ2z9P+EFXpsxYFKvYxd
         mSfVqMVrDPcCNJ8TOoJrhPqigHkb19llW2UKtzm3Y6RhGWFBVxI125l/+D9eGiQZy0
         UacpisbTshg9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, prabhakar.csengg@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 30/93] media: davinci: vpif: add missing of_node_put() in vpif_probe()
Date:   Thu, 11 Aug 2022 11:41:24 -0400
Message-Id: <20220811154237.1531313-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit bb45f5433f23cf103ba29c9692ee553e061f2cb4 ]

of_graph_get_next_endpoint() returns an 'endpoint' node pointer
with refcount incremented. The refcount should be decremented
before returning from vpif_probe().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti/davinci/vpif.c b/drivers/media/platform/ti/davinci/vpif.c
index 97ef770266af..da27da4c165a 100644
--- a/drivers/media/platform/ti/davinci/vpif.c
+++ b/drivers/media/platform/ti/davinci/vpif.c
@@ -469,6 +469,7 @@ static int vpif_probe(struct platform_device *pdev)
 					      endpoint);
 	if (!endpoint)
 		return 0;
+	of_node_put(endpoint);
 
 	/*
 	 * For DT platforms, manually create platform_devices for
-- 
2.35.1

