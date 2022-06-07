Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D6E541BEF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381952AbiFGVza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381899AbiFGVtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD12223B548;
        Tue,  7 Jun 2022 12:08:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00B3461768;
        Tue,  7 Jun 2022 19:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DB9C385A5;
        Tue,  7 Jun 2022 19:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628907;
        bh=m0SeXDt7dXNDBS1M6Vwhu4t2wYrFNNLHH7CkYwqfgcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQyVf1WcSds4a/qWWTmGCNy2qlfzdei8M2wmL92vzM8LqOOGy6NntQjPoD4URbQo4
         dcxq0e3GQuEKq5w7WODB49ZMVGUqsgbry+oax2YSUyZ54z8WoKjd335dXis5gR5N6P
         ez7zacCP2tisLAVNn+EPa8ctwiA9Y2JrtWne4h3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 497/879] ASoC: codecs: lpass: Fix passing zero to PTR_ERR
Date:   Tue,  7 Jun 2022 19:00:15 +0200
Message-Id: <20220607165017.297497708@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 81e7b165c45e94188ae8f1134b57f27d1f35452f ]

sound/soc/codecs/lpass-macro-common.c:28 lpass_macro_pds_init() warn: passing zero to 'PTR_ERR'
sound/soc/codecs/lpass-macro-common.c:38 lpass_macro_pds_init() warn: passing zero to 'PTR_ERR'
sound/soc/codecs/lpass-macro-common.c:54 lpass_macro_pds_init() warn: passing zero to 'ERR_PTR'

dev_pm_domain_attach_by_name() may return NULL, set 'ret' as
-ENODATA to fix this warning.

Fixes: 1a8ee4cf8418 ("ASoC: codecs: Fix error handling in power domain init and exit handlers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20220516120909.36356-1-yuehaibing@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-macro-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/lpass-macro-common.c b/sound/soc/codecs/lpass-macro-common.c
index 3c661fd61173..1b9082d237c1 100644
--- a/sound/soc/codecs/lpass-macro-common.c
+++ b/sound/soc/codecs/lpass-macro-common.c
@@ -25,7 +25,7 @@ struct lpass_macro *lpass_macro_pds_init(struct device *dev)
 
 	l_pds->macro_pd = dev_pm_domain_attach_by_name(dev, "macro");
 	if (IS_ERR_OR_NULL(l_pds->macro_pd)) {
-		ret = PTR_ERR(l_pds->macro_pd);
+		ret = l_pds->macro_pd ? PTR_ERR(l_pds->macro_pd) : -ENODATA;
 		goto macro_err;
 	}
 
@@ -35,7 +35,7 @@ struct lpass_macro *lpass_macro_pds_init(struct device *dev)
 
 	l_pds->dcodec_pd = dev_pm_domain_attach_by_name(dev, "dcodec");
 	if (IS_ERR_OR_NULL(l_pds->dcodec_pd)) {
-		ret = PTR_ERR(l_pds->dcodec_pd);
+		ret = l_pds->dcodec_pd ? PTR_ERR(l_pds->dcodec_pd) : -ENODATA;
 		goto dcodec_err;
 	}
 
-- 
2.35.1



