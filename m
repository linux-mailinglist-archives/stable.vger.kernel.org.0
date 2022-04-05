Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD08D4F36BE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242480AbiDELHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348638AbiDEJsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B9633E82;
        Tue,  5 Apr 2022 02:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6378E616D9;
        Tue,  5 Apr 2022 09:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714E6C385A6;
        Tue,  5 Apr 2022 09:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151259;
        bh=ybT7+5zSo63r+ZXukOXUPT5DtGFQtgkMrq0vaM9uPB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9JmSUeXplX152/DUmqLjeM/oA7SDUMhAlejZlFi4R4eLhoQbOuXSx5UNes9La8KM
         biOccbbP/pne0S7cHA2KkyQqGSWbJkBXXGrI1w/uT+PBHp5bv5ds3M+W7afH+Ergst
         HF7kcQJHAQKWyuoy13fnaSVzXz38LpYyId3B3WkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/913] ASoC: fsi: Add check for clk_enable
Date:   Tue,  5 Apr 2022 09:23:33 +0200
Message-Id: <20220405070350.367087936@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 405afed8a728f23cfaa02f75bbc8bdd6b7322123 ]

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: ab6f6d85210c ("ASoC: fsi: add master clock control functions")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220302062844.46869-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/fsi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index cdf3b7f69ba7..e9a1eb6bdf66 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -816,14 +816,27 @@ static int fsi_clk_enable(struct device *dev,
 			return ret;
 		}
 
-		clk_enable(clock->xck);
-		clk_enable(clock->ick);
-		clk_enable(clock->div);
+		ret = clk_enable(clock->xck);
+		if (ret)
+			goto err;
+		ret = clk_enable(clock->ick);
+		if (ret)
+			goto disable_xck;
+		ret = clk_enable(clock->div);
+		if (ret)
+			goto disable_ick;
 
 		clock->count++;
 	}
 
 	return ret;
+
+disable_ick:
+	clk_disable(clock->ick);
+disable_xck:
+	clk_disable(clock->xck);
+err:
+	return ret;
 }
 
 static int fsi_clk_disable(struct device *dev,
-- 
2.34.1



