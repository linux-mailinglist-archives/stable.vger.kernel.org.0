Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3A594D29
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbiHPAgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbiHPAek (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D567B187FBC;
        Mon, 15 Aug 2022 13:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD70611E2;
        Mon, 15 Aug 2022 20:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D1EC433C1;
        Mon, 15 Aug 2022 20:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595840;
        bh=zKoOUGLc9GCXGCCdM2OM3y02a5kExyeYGGHCHrGuQzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcSwslqt51fB5uQPqo+DYSkeR31tjax4FMFeyQQAWbwwMWSOMt1ub1OQXFNLBP9jO
         7cX5ExnLMmjqKOUo595F/TMvlfYpAtJmbwsKL/faQ/v4pq5SpusLsdKnfQccCNI/ye
         FiLXU7c8qyt/9DL7gr3zkkLTj/4sVBZbQcMQVRVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0891/1157] ASoC: samsung: Fix error handling in aries_audio_probe
Date:   Mon, 15 Aug 2022 20:04:07 +0200
Message-Id: <20220815180515.081357047@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 3e2649c5e8643bea0867bb1dd970fedadb0eb7f3 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
This function is missing of_node_put(cpu) in the error path.
Fix this by goto out label. of_node_put() will check NULL pointer.

Fixes: 7a3a7671fa6c ("ASoC: samsung: Add driver for Aries boards")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220603130640.37624-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/aries_wm8994.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/aries_wm8994.c b/sound/soc/samsung/aries_wm8994.c
index bb0cf4244e00..edee02d7f100 100644
--- a/sound/soc/samsung/aries_wm8994.c
+++ b/sound/soc/samsung/aries_wm8994.c
@@ -628,8 +628,10 @@ static int aries_audio_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	codec = of_get_child_by_name(dev->of_node, "codec");
-	if (!codec)
-		return -EINVAL;
+	if (!codec) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	for_each_card_prelinks(card, i, dai_link) {
 		dai_link->codecs->of_node = of_parse_phandle(codec,
-- 
2.35.1



