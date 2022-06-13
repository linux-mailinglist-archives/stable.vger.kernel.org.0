Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F8B54870D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354594AbiFMMwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351091AbiFMMwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:52:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0514641C;
        Mon, 13 Jun 2022 04:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A81FECE118D;
        Mon, 13 Jun 2022 11:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95614C3411C;
        Mon, 13 Jun 2022 11:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118741;
        bh=MK2DExhRzPuMniHrsCO4Hu8aINQml8/b84nZ7z6XkVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1R3jqXY68C5574H2ggQZFdOerKqQxUDSx5R1uLgu0pWCVqSgaJjpkvL/L+WnM+sFH
         fENdGXkZS7hr0F5VGl8S5FfFvx7Ex9LrZ//cK2/xhfY/6P/OkRZAnaSDVX8F/jaOiQ
         uvOspqP/2M4qBktoXn7Urv967/tBXqmJGg0+b/hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/247] remoteproc: imx_rproc: Ignore create mem entry for resource table
Date:   Mon, 13 Jun 2022 12:08:33 +0200
Message-Id: <20220613094923.264637509@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 58b7c856519fe946620ee68dd0c37bd3c695484a ]

Resource table is used by Linux to get information published by
remote processor. It should be not be used for memory allocation, so
not create rproc mem entry.

Fixes: b29b4249f8f0 ("remoteproc: imx_rproc: add i.MX specific parse fw hook")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20220415025737.1561976-1-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 05c39e1c56b4..59eae605ad59 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -447,6 +447,9 @@ static int imx_rproc_prepare(struct rproc *rproc)
 		if (!strcmp(it.node->name, "vdev0buffer"))
 			continue;
 
+		if (!strcmp(it.node->name, "rsc-table"))
+			continue;
+
 		rmem = of_reserved_mem_lookup(it.node);
 		if (!rmem) {
 			dev_err(priv->dev, "unable to acquire memory-region\n");
-- 
2.35.1



