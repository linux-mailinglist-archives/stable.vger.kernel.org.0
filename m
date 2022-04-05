Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72404F36C8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344813AbiDELHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348747AbiDEJsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1D9434A1;
        Tue,  5 Apr 2022 02:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0764C616D2;
        Tue,  5 Apr 2022 09:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EEEC385A2;
        Tue,  5 Apr 2022 09:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151279;
        bh=kMkP7LIZyKrZImQIvxCIdYrVte6hWmV+cZJmJGwvNjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/GUr1FWvpxOG+4NdQvTn31KxKJ1uQJgeoJ/qmzuvx0CnVXyMoLI1CkgNUagU714z
         w8HjdssMVXM5EE0l+pNj8+fd0YIi+pcP7L+oeCTyH+8S0LyNPB/cQ7FJqU2IsTcNsr
         0NMOp9WAL8ZLlFy1wKTZf/bUUxvosIefv0n5uiDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/913] ASoC: SOF: Add missing of_node_put() in imx8m_probe
Date:   Tue,  5 Apr 2022 09:23:39 +0200
Message-Id: <20220405070350.546765111@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit 5575f7f49134c7386a684335c9007737c606d3b5 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: afb93d716533 ("ASoC: SOF: imx: Add i.MX8M HW support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308023325.31702-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/imx8m.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/imx/imx8m.c b/sound/soc/sof/imx/imx8m.c
index 892e1482f97f..b3d3edc36bb0 100644
--- a/sound/soc/sof/imx/imx8m.c
+++ b/sound/soc/sof/imx/imx8m.c
@@ -191,6 +191,7 @@ static int imx8m_probe(struct snd_sof_dev *sdev)
 	}
 
 	ret = of_address_to_resource(res_node, 0, &res);
+	of_node_put(res_node);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to get reserved region address\n");
 		goto exit_pdev_unregister;
-- 
2.34.1



