Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C466B453B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbjCJOcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjCJObn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:31:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4CA17CE6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:30:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F09C618C9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65968C433EF;
        Fri, 10 Mar 2023 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458656;
        bh=RmXnX4O5gi5wdoQMcgShlUdW8JUpiGkDCnDglZCJ81M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1Bv+RwIvqbKnMn8RcTETlvQB2NBTIfkeclKAfxOeRrGKx25T+OYmWCQGvEE0fokd
         7Q0GLoD+ZvN19UZ4YHAlOlko8ppxkEAuv2f18EOa5GwSyuOacEjwqOgYg23NnriHuM
         yvSFsZgqKH9ib2HY3Jxo26LImXlVTReSUHKB7Ajg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/357] gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()
Date:   Fri, 10 Mar 2023 14:36:30 +0100
Message-Id: <20230310133738.461992021@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 9afdf98cfdfa2ba8ec068cf08c5fcdc1ed8daf3f ]

In ipu_add_client_devices(), we need to call of_node_put() for
reference returned by of_graph_get_port_by_id() in fail path.

Fixes: 17e052175039 ("gpu: ipu-v3: Do not bail out on missing optional port nodes")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220720152227.1288413-1-windhl@126.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220720152227.1288413-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index b3dae9ec1a38b..528812bf84da7 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1235,6 +1235,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
-- 
2.39.2



