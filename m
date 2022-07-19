Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52E1579EF8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbiGSNIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243090AbiGSNIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C83BB5DD;
        Tue, 19 Jul 2022 05:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15E13B81B08;
        Tue, 19 Jul 2022 12:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71072C341C6;
        Tue, 19 Jul 2022 12:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233647;
        bh=iA9/mffzugg5arwehs0PfA8MRLkpYI57QgbLR0O4YSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAE7vuHxdnsQxQxLRDN5rarr4pRSztLCgcVsWnsHcc0SLJo3e4YsFmaBH7cdJCWG3
         i6KmqrVIrvwlHmz5v3aVAT18FTTPakGrV0tpgns7LdYpgp5Tz0l9MlyrNyIPpR68D3
         8j26khow727DtM15KrqENIbAd/U80NzuVb2E5/Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yassine Oudjana <y.oudjana@protonmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 194/231] ASoC: wcd9335: Remove RX channel from old list before adding it to a new one
Date:   Tue, 19 Jul 2022 13:54:39 +0200
Message-Id: <20220719114730.438303506@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yassine Oudjana <y.oudjana@protonmail.com>

[ Upstream commit be6dd72edb216f20fc80e426ece9fe9b8aabf033 ]

Currently in slim_rx_mux_put, an RX channel gets added to a new list
even if it is already in one. This can mess up links and make either
it, the new list head, or both, get linked to the wrong entries.
This can cause an entry to link to itself which in turn ends up
making list_for_each_entry in other functions loop infinitely.
To avoid issues, always remove the RX channel from any list it's in
before adding it to a new list.

Signed-off-by: Yassine Oudjana <y.oudjana@protonmail.com>
Link: https://lore.kernel.org/r/20220606152226.149164-1-y.oudjana@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 1e60db4056ad..12be043ee9a3 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1289,9 +1289,12 @@ static int slim_rx_mux_put(struct snd_kcontrol *kc,
 
 	wcd->rx_port_value[port_id] = ucontrol->value.enumerated.item[0];
 
+	/* Remove channel from any list it's in before adding it to a new one */
+	list_del_init(&wcd->rx_chs[port_id].list);
+
 	switch (wcd->rx_port_value[port_id]) {
 	case 0:
-		list_del_init(&wcd->rx_chs[port_id].list);
+		/* Channel already removed from lists. Nothing to do here */
 		break;
 	case 1:
 		list_add_tail(&wcd->rx_chs[port_id].list,
-- 
2.35.1



