Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067AC5902ED
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbiHKQRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbiHKQQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:16:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10802C2EB0;
        Thu, 11 Aug 2022 08:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33AD161341;
        Thu, 11 Aug 2022 15:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6B7C433D6;
        Thu, 11 Aug 2022 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233588;
        bh=61HETrOWiV+nAOKQLT0ew2bzYevhgS2U+oCmiRYnM1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QG5kYELXiBr6amSV2hbOSR7zgzU1FdelXO051EiEqPzTDPHW3Q6DJmhDnP5m+omBg
         Skf0W4jqUvpZw7bN+6fE/FiQJ5PG4GfaSkrjY/D+3rxI/+QiSFnWOE3ljK5B1gFmvm
         j+CtOnUw5hDX9afehlIw6VhLvECm4L3a/XIveLNyN/mGgtTyLGOSfjBmRO/khunhG2
         A42WECkY3Pg+6/iZI7w/+IcTLx/UK2bKxwv5DCKSrqO60m5sK07dIHj0me7taHBGib
         6VqcaX5Qalihalt5LnYwNpoiCC8SGB7g17WcQVuHsVmi+b/vGbGfcAEx2f2qgIMpQc
         t6FKOLa6p0XBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        prabhakar.mahadev-lad.rj@bp.renesas.com, johan@kernel.org,
        laurent.pinchart@ideasonboard.com, cai.huoqing@linux.dev,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/69] media: davinci: vpif: add missing of_node_put() in vpif_probe()
Date:   Thu, 11 Aug 2022 11:55:34 -0400
Message-Id: <20220811155632.1536867-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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
 drivers/media/platform/davinci/vpif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 8ffc01c606d0..b4c78dce4d41 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -469,6 +469,7 @@ static int vpif_probe(struct platform_device *pdev)
 					      endpoint);
 	if (!endpoint)
 		return 0;
+	of_node_put(endpoint);
 
 	/*
 	 * For DT platforms, manually create platform_devices for
-- 
2.35.1

