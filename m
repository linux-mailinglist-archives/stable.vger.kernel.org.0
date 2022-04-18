Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3694F50561A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbiDRNcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243720AbiDRN3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:29:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D183FBEE;
        Mon, 18 Apr 2022 05:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21799612C3;
        Mon, 18 Apr 2022 12:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE7C385A1;
        Mon, 18 Apr 2022 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286424;
        bh=pbWOlWjYLriqB3tA+WF6LhE82z+m6RnhJZXV0L8KsbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mY2w91xtZp1i+7NfZ6C4pUiLgL/Sx+NA5YMOG5fOOpymAHiBMHQY9lgAfDAnxKrfE
         XQcQLtbM629/GtnJ5PdaAhrZMZaCu3q+627QVZKKrVQl8BMU2MwHD7M5oa07WmF/XI
         oRVITD8ko1RMFoxPYo+BP5jBsgoAWrkecGsOnqQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/284] ASoC: fsi: Add check for clk_enable
Date:   Mon, 18 Apr 2022 14:11:11 +0200
Message-Id: <20220418121213.245644392@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 6d3c7706d93f..b564accb6098 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -820,14 +820,27 @@ static int fsi_clk_enable(struct device *dev,
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



