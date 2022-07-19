Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08EA579EFB
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243104AbiGSNIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243160AbiGSNId (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF1ABB8D8;
        Tue, 19 Jul 2022 05:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 846F46090A;
        Tue, 19 Jul 2022 12:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F05DC341C6;
        Tue, 19 Jul 2022 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233650;
        bh=dt8pDqk8iKTyANiXWzkfAhvww3xMsxUF+gbazu59Dis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYdPlMl3NM4aPqqM+nXWqZZzgnq1O9/ytPJzFt45I573QufAP0dVFZHOqLNufAkk9
         z06gbpFzpLnA7bVTAoKIlhovlpvd5Sn5JCazKR3Zc6wwdfFNEqrbJZ5sTuTkk6ZA9p
         s9x8WYfXQcVgUXxl/Np22pKh9HJzZJ9rXms9iKww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 195/231] ASoC: wcd9335: Fix spurious event generation
Date:   Tue, 19 Jul 2022 13:54:40 +0200
Message-Id: <20220719114730.508351043@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit a7786cbae4b2732815da98efa39df96746b5bd0d ]

The slimbus mux put operation unconditionally reports a change in value
which means that spurious events are generated. Fix this by exiting early
in that case.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220603124609.4024666-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 12be043ee9a3..aa685980a97b 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1287,6 +1287,9 @@ static int slim_rx_mux_put(struct snd_kcontrol *kc,
 	struct snd_soc_dapm_update *update = NULL;
 	u32 port_id = w->shift;
 
+	if (wcd->rx_port_value[port_id] == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd->rx_port_value[port_id] = ucontrol->value.enumerated.item[0];
 
 	/* Remove channel from any list it's in before adding it to a new one */
-- 
2.35.1



