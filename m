Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF565F2A2A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiJCHbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiJCHau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:30:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F5B1FCFF;
        Mon,  3 Oct 2022 00:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E605E60FA4;
        Mon,  3 Oct 2022 07:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0555BC433C1;
        Mon,  3 Oct 2022 07:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781513;
        bh=bzT6vyxwK9l/S/M9haD835cIwl5EwhBCeG4yOlarAWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIvuVArnBGtYhRlBdb8PaLOkGbV6C7VU3UKCtkuR/kIxMBN9pAFio/52Pdh+OUJQu
         QcyQrlmBfoGTX6ldiQWFM+FqUOWLfhecKlDwFgtu03drspX9b9tFUWNhArFbMnEb/s
         st31KjQMIKMmQAcw7bqH8nOTzc4ErqapPr7t1H7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/83] ASoC: imx-card: Fix refcount issue with of_node_put
Date:   Mon,  3 Oct 2022 09:11:12 +0200
Message-Id: <20221003070723.175841129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit d56ba9a04d7548d4149c46ec86a0e3cc41a70f4a ]

imx_card_parse_of will search all the node with loop,
if there is defer probe happen in the middle of loop,
the previous released codec node will be released
twice, then cause refcount issue.

Here assign NULL to pointer of released nodes to fix
the issue.

Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1663059601-29259-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 593d69b96523..d59f5efbf7ed 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -698,6 +698,10 @@ static int imx_card_parse_of(struct imx_card_data *data)
 		of_node_put(cpu);
 		of_node_put(codec);
 		of_node_put(platform);
+
+		cpu = NULL;
+		codec = NULL;
+		platform = NULL;
 	}
 
 	return 0;
-- 
2.35.1



