Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C7C58FFE7
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiHKPf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiHKPeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407AF98A69;
        Thu, 11 Aug 2022 08:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75CB36162D;
        Thu, 11 Aug 2022 15:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D61C433D7;
        Thu, 11 Aug 2022 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231962;
        bh=aVDfoQXhnCJz3FkHiF1y08f1OF1Zx0Iw4ujPQBH0Bik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZbFGF7VdIL8rzt0i9Bep4/6fCsR3jZpAmzP4x9PS79cSWLIihgy7Rs8fpNpYZHn0
         uQ/kar1qEfiaaz7OfZNz1wPfJIvN/M2rYxzbxwnQbNu7dNv6zShWzgylpfJCDALpn2
         PueXHAowka+oZBbSgIeh2C8xfvifDaVl7cKhFVM5mURhc6jyydIR99Ft6/0/dfYjco
         5eSmwwrcRQBpmJnT8kO8g6NzQbefeSWYnHDYArvJo8Z1JBeuaPx4VXFZUeHhMswBQ9
         nIOiV/qE3Qck6vrD7yVaPZ+ltMQ4taVjtD5Il0cIOI+SgRkrBZNkC9+8BrayAuoG3u
         Dv00WAhOx9l3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, prabhakar.csengg@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 031/105] media: davinci: vpif: add missing of_node_put() in vpif_probe()
Date:   Thu, 11 Aug 2022 11:27:15 -0400
Message-Id: <20220811152851.1520029-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

