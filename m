Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A959A1F8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352800AbiHSQ1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353165AbiHSQ0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:26:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659F8119130;
        Fri, 19 Aug 2022 09:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83DB617A7;
        Fri, 19 Aug 2022 16:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31A7C433D7;
        Fri, 19 Aug 2022 16:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925041;
        bh=qQHUtZWaWupbYZelFOYe4CltnFVzO3H9peKF0dVanHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6TQ8yhpXCo15rDBuu+t6q1QssSSStrKXJZKyJeuj3RyyxGI2SZKfpnv1wnLY01ef
         AgUGANcGgoOPrsE4s7dSZeji7k20x9lqeQwO1YdioU+8JUCRSzfSitzgpUpdFD8ZIT
         pKh/8b3NkilVsb7Hy/KAPIFyyf9lfAI98s73AsbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/545] ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe
Date:   Fri, 19 Aug 2022 17:42:14 +0200
Message-Id: <20220819153845.673909883@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit 0a034d93ee929a9ea89f3fa5f1d8492435b9ee6e ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: b6bc07d4360d ("ASoC: cros_ec_codec: support WoV")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20220603131043.38907-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cros_ec_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cros_ec_codec.c b/sound/soc/codecs/cros_ec_codec.c
index 5c3b7e5e55d2..dedbaba83792 100644
--- a/sound/soc/codecs/cros_ec_codec.c
+++ b/sound/soc/codecs/cros_ec_codec.c
@@ -994,6 +994,7 @@ static int cros_ec_codec_platform_probe(struct platform_device *pdev)
 			dev_dbg(dev, "ap_shm_phys_addr=%#llx len=%#x\n",
 				priv->ap_shm_phys_addr, priv->ap_shm_len);
 		}
+		of_node_put(node);
 	}
 #endif
 
-- 
2.35.1



