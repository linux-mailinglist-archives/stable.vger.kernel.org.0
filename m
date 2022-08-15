Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9205943B8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348942AbiHOW3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351049AbiHOW1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AFE6CF63;
        Mon, 15 Aug 2022 12:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E968B80EB2;
        Mon, 15 Aug 2022 19:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F9DC433D6;
        Mon, 15 Aug 2022 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592788;
        bh=vG/vDzx6+5VGFKUst4YBhuRJs1eVtMEp3W1+Ucpt4Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0JxvcnDmOFvKGUYQJa0g4ewZ4okQFVStZhb+tNcQx+5VOocrJNQuLutFN1fA066H
         7Fkr+hLm8AnzT1n6CFkoB3lzknyRsAupinOrpGEgC82/+LF9UHufkKHKpZUF+XbleK
         Ro2gIQ2WX80spwCXLUCA8dkmhd71MHcCgssDXR2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0845/1095] remoteproc: imx_rproc: Fix refcount leak in imx_rproc_addr_init
Date:   Mon, 15 Aug 2022 20:04:04 +0200
Message-Id: <20220815180504.291023472@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 61afafe8b938bc74841cf4b1a73dd08b9d287c5a ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not needed anymore.
This function has two paths missing of_node_put().

Fixes: 6e962bfe56b9 ("remoteproc: imx_rproc: add missing of_node_put")
Fixes: a0ff4aa6f010 ("remoteproc: imx_rproc: add a NXP/Freescale imx_rproc driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220512045558.7142-1-linmq006@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 91eb037089ef..f17bb41a6551 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -562,16 +562,17 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 
 		node = of_parse_phandle(np, "memory-region", a);
 		/* Not map vdevbuffer, vdevring region */
-		if (!strncmp(node->name, "vdev", strlen("vdev")))
+		if (!strncmp(node->name, "vdev", strlen("vdev"))) {
+			of_node_put(node);
 			continue;
+		}
 		err = of_address_to_resource(node, 0, &res);
+		of_node_put(node);
 		if (err) {
 			dev_err(dev, "unable to resolve memory region\n");
 			return err;
 		}
 
-		of_node_put(node);
-
 		if (b >= IMX_RPROC_MEM_MAX)
 			break;
 
-- 
2.35.1



