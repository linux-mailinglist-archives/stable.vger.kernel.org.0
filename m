Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E99579CC7
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbiGSMnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbiGSMmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F74C7E01B;
        Tue, 19 Jul 2022 05:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F63CB81B89;
        Tue, 19 Jul 2022 12:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCEEC341C6;
        Tue, 19 Jul 2022 12:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232976;
        bh=08m7YkgMf00+tBrPAp/k1bxRwMkOC+fQBhyogyRaGSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs4PxdjoxGy1FFxqUMJeg/gIkPhuFYkeW549/xtZdBqvYnA6DA5edhb6/ogmXwqF3
         c24XTr1bI5Rv9t8bsEUyPDRolV2JO+vGuImK94xonboCKXDXAgzlrIfVbX6V7xxrrT
         uD6dxT8J1O5WcP+5JvsR306Dwjfbpx8fqZKiBXTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/167] ASoC: ops: Fix off by one in range control validation
Date:   Tue, 19 Jul 2022 13:54:23 +0200
Message-Id: <20220719114709.244406088@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

[ Upstream commit 5871321fb4558c55bf9567052b618ff0be6b975e ]

We currently report that range controls accept a range of 0..(max-min) but
accept writes in the range 0..(max-min+1). Remove that extra +1.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220604105246.4055214-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index f32ba64c5dda..e73360e9de8f 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -526,7 +526,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	if (mc->platform_max && tmp > mc->platform_max)
 		return -EINVAL;
-	if (tmp > mc->max - mc->min + 1)
+	if (tmp > mc->max - mc->min)
 		return -EINVAL;
 
 	if (invert)
@@ -547,7 +547,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		if (mc->platform_max && tmp > mc->platform_max)
 			return -EINVAL;
-		if (tmp > mc->max - mc->min + 1)
+		if (tmp > mc->max - mc->min)
 			return -EINVAL;
 
 		if (invert)
-- 
2.35.1



