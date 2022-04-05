Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1C4F27E0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiDEIJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiDEH77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016A1388B;
        Tue,  5 Apr 2022 00:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 928B26167D;
        Tue,  5 Apr 2022 07:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B1AC340EE;
        Tue,  5 Apr 2022 07:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145444;
        bh=f7/O1TsfZJjElBzDzZA88UduJ+DN69USLv6+AqBK0a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFa0lyc78KCf6gI6ByAsaSE5boLoAqa4g9ZdGo1S8LuETQ0O20CjPvCAyEXKsDqgG
         uZxjK5ctr3Z5Nv7ZdHsJUwDtc9MZoCmtezilfU6T9yhxpHng6oJL7/Sk+WgIr2pgd0
         uMJGDQYyIUgYqHcD21cxh+u6HfxEYZpyYk+Z8KUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0407/1126] ASoC: mxs: Fix error handling in mxs_sgtl5000_probe
Date:   Tue,  5 Apr 2022 09:19:14 +0200
Message-Id: <20220405070419.572099325@linuxfoundation.org>
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
index 2412dc7e65d4..746f40938675 100644
--- a/sound/soc/mxs/mxs-sgtl5000.c
+++ b/sound/soc/mxs/mxs-sgtl5000.c
@@ -118,6 +118,9 @@ static int mxs_sgtl5000_probe(struct platform_device *pdev)
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



