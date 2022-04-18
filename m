Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18095054A1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiDRNVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbiDRNSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A817D3BA4F;
        Mon, 18 Apr 2022 05:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A1E5B80EE2;
        Mon, 18 Apr 2022 12:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21D3C385A1;
        Mon, 18 Apr 2022 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286303;
        bh=0cNLl7cicECeRKenY9cJleGElIN2aSm8Y4NKmZ9mrpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKdyl89dXb75xp32U9vNkf6eJlPs96fiFq3YtbWuSx1onq9S1XUW0H7npucraYViz
         GPKcjwTrM0+ImOpJzqb06MN0ntRWGDawWTCcpTFKgObucTTzYhqFUjoWQh/zWcqHv0
         er7yo3oNCl1He6Gyzr08n6GKHuSvPWuD49yIIX4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/284] ASoC: mxs: Fix error handling in mxs_sgtl5000_probe
Date:   Mon, 18 Apr 2022 14:11:14 +0200
Message-Id: <20220418121213.330186001@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6ae0a4d8fec551ec581d620f0eb1fe31f755551c ]

This function only calls of_node_put() in the regular path.
And it will cause refcount leak in error paths.
For example, when codec_np is NULL, saif_np[0] and saif_np[1]
are not NULL, it will cause leaks.

of_node_put() will check if the node pointer is NULL, so we can
call it directly to release the refcount of regular pointers.

Fixes: e968194b45c4 ("ASoC: mxs: add device tree support for mxs-sgtl5000")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220308020146.26496-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mxs/mxs-sgtl5000.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mxs/mxs-sgtl5000.c b/sound/soc/mxs/mxs-sgtl5000.c
index 2ed3240cc682..d5e1a5e7c238 100644
--- a/sound/soc/mxs/mxs-sgtl5000.c
+++ b/sound/soc/mxs/mxs-sgtl5000.c
@@ -112,6 +112,9 @@ static int mxs_sgtl5000_probe(struct platform_device *pdev)
 	codec_np = of_parse_phandle(np, "audio-codec", 0);
 	if (!saif_np[0] || !saif_np[1] || !codec_np) {
 		dev_err(&pdev->dev, "phandle missing or invalid\n");
+		of_node_put(codec_np);
+		of_node_put(saif_np[0]);
+		of_node_put(saif_np[1]);
 		return -EINVAL;
 	}
 
-- 
2.34.1



