Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF0E657EF0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiL1P7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiL1P7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E2C18E05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:59:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 824D46155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91477C433D2;
        Wed, 28 Dec 2022 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243163;
        bh=D5xTLGtfH6tIVUWRU4u3V1+jEB8UI/2PGD0znMVXnKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ3HmBy5ZIz82cVhVscvL+14ikTMQb4NhN3B55iXU/kUfuso5B1GGo0SoLaTifKCW
         hN9pto9x9fXOuifJ7Qi/wCr0F7qMFAZW4uq8FxkmdOzdVlxQa4cgaf6DU9ImKAQ0xE
         mMvFddv7IBqQUu+Zl/oamC0lAqDQ2qaL3vezMWJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 690/731] ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()
Date:   Wed, 28 Dec 2022 15:43:17 +0100
Message-Id: <20221228144316.465477813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 8ab2d12c726f0fde0692fa5d81d8019b3dcd62d0 ]

The of_get_next_child() returns a node with refcount incremented, and
decrements the refcount of prev. So in the error path of the while loop,
of_node_put() needs be called for cpu_ep.

Fixes: fce9b90c1ab7 ("ASoC: audio-graph-card: cleanup DAI link loop method - step2")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/1670228127-13835-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index 28cbcdb56857..89814f68ff56 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -483,8 +483,10 @@ static int __graph_for_each_link(struct asoc_simple_priv *priv,
 			of_node_put(codec_ep);
 			of_node_put(codec_port);
 
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(cpu_ep);
 				return ret;
+			}
 
 			codec_port_old = codec_port;
 		}
-- 
2.35.1



