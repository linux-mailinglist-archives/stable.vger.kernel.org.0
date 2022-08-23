Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A824D59E1F4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349775AbiHWKnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355963AbiHWKlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27646580B;
        Tue, 23 Aug 2022 02:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDD66156F;
        Tue, 23 Aug 2022 09:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAF4C433D6;
        Tue, 23 Aug 2022 09:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245715;
        bh=M8ZpMxABeDnxEiGfzWmkt39Q5w0XsLcGayuTXLXz9zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dx2B62944E8OBdJ88oguqhh0WwZ0ax8wVDUFBbJznnJv72x4dp6bfu+QPiEDCRpAP
         1hk4/z4HihTv404vnTZmBAzhlQWqOeHyClfFvOvMLPWMBOm4BK0XElX6eSen/a8M5m
         MtE0BQJvfIC7vjNwKl1OjbDJkXceTCwyFXWW4X1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/287] ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()
Date:   Tue, 23 Aug 2022 10:25:35 +0200
Message-Id: <20220823080106.332907599@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 673f58f62ca6fc98979d1cf3fe89c3ff33f29b2e ]

find_first_zero_bit() returns MAX_COPPS_PER_PORT at max here.
So 'idx' should be tested with ">=" or the test can't match.

Fixes: 7b20b2be51e1 ("ASoC: qdsp6: q6adm: Add q6adm driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0fca3271649736053eb9649d87e1ca01b056be40.1658394124.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6adm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/qdsp6/q6adm.c b/sound/soc/qcom/qdsp6/q6adm.c
index 932c3ebfd252..01f9127daf5c 100644
--- a/sound/soc/qcom/qdsp6/q6adm.c
+++ b/sound/soc/qcom/qdsp6/q6adm.c
@@ -218,7 +218,7 @@ static struct q6copp *q6adm_alloc_copp(struct q6adm *adm, int port_idx)
 	idx = find_first_zero_bit(&adm->copp_bitmap[port_idx],
 				  MAX_COPPS_PER_PORT);
 
-	if (idx > MAX_COPPS_PER_PORT)
+	if (idx >= MAX_COPPS_PER_PORT)
 		return ERR_PTR(-EBUSY);
 
 	c = kzalloc(sizeof(*c), GFP_ATOMIC);
-- 
2.35.1



