Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699B3595087
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbiHPEml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiHPElk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:41:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6A3D2B3B;
        Mon, 15 Aug 2022 13:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98306B8114A;
        Mon, 15 Aug 2022 20:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F3AC433C1;
        Mon, 15 Aug 2022 20:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595679;
        bh=OBgG/fVVKPQLvqHzjSlNXO7UyFxMhf3DO59n0ZEWzTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaIvpXblbcNUqw2Eam/blmjrLGcI+Sx51Fwlde2nH8pxWHly3w1tMtmafQgs5gBTo
         8NE3uvXRpCnJY2PrA05B8zLMABae2qdFytATusjXfix05cbk80cejXEfJRzLpgqUoS
         cpyRugJ8VHC018FxEs0mmbTmsMjNzvMxVrZLuLs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0841/1157] mmc: core: quirks: Add of_node_put() when breaking out of loop
Date:   Mon, 15 Aug 2022 20:03:17 +0200
Message-Id: <20220815180513.131090688@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 883c1d6fa4368a63cae2d6ae2d9c91141c60e233 ]

In mmc_fixup_of_compatible_match(), we should call of_node_put()
when breaking out of for_each_child_of_node() which will increase
and decrease the refcount during one iteration.

Fixes: b360b1102670 ("mmc: core: allow to match the device tree to apply quirks")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220719091051.1210806-1-windhl@126.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/quirks.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index f879dc63d936..be4393988086 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -163,8 +163,10 @@ static inline bool mmc_fixup_of_compatible_match(struct mmc_card *card,
 	struct device_node *np;
 
 	for_each_child_of_node(mmc_dev(card->host)->of_node, np) {
-		if (of_device_is_compatible(np, compatible))
+		if (of_device_is_compatible(np, compatible)) {
+			of_node_put(np);
 			return true;
+		}
 	}
 
 	return false;
-- 
2.35.1



