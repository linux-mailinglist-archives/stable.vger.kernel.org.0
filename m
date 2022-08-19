Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43759A491
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353400AbiHSQjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353434AbiHSQhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:37:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACBE123C8A;
        Fri, 19 Aug 2022 09:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0CD8B82802;
        Fri, 19 Aug 2022 16:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A830C433C1;
        Fri, 19 Aug 2022 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925264;
        bh=MR/WQ03ufFX6kSt75F16agGty5l0x1n6KmHP4Yzz8Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/DsuYBV/iF62Sz23gIK4fsugyijXqXiRhCIc+/eapZA3QpqE28qhcZNSW8wa+OkR
         U4XfXYC8MomHUrMKq+C+levOef4qwnPXs0wutO/devvR6vdaJ0tzoUdhvpwUW2PGMA
         gPXc7LHQwvjbpi7U+UjS/ih6IzEI3G8TvqsFG9+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/545] ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()
Date:   Fri, 19 Aug 2022 17:42:59 +0200
Message-Id: <20220819153847.729459572@linuxfoundation.org>
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
index 72f29720398c..182d36a34faf 100644
--- a/sound/soc/qcom/qdsp6/q6adm.c
+++ b/sound/soc/qcom/qdsp6/q6adm.c
@@ -217,7 +217,7 @@ static struct q6copp *q6adm_alloc_copp(struct q6adm *adm, int port_idx)
 	idx = find_first_zero_bit(&adm->copp_bitmap[port_idx],
 				  MAX_COPPS_PER_PORT);
 
-	if (idx > MAX_COPPS_PER_PORT)
+	if (idx >= MAX_COPPS_PER_PORT)
 		return ERR_PTR(-EBUSY);
 
 	c = kzalloc(sizeof(*c), GFP_ATOMIC);
-- 
2.35.1



