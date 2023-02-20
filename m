Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF45169CDFA
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjBTNyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBTNys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:54:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDC51E9F9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:54:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B673AB80B4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFEDC433D2;
        Mon, 20 Feb 2023 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901283;
        bh=+Dpc3UPpgbhslDUa1Pjver094CNhUa16gcojS/lg89A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUQ08/4yDbvQ+vEdPDgnbHgQk3VVIfqf7G7ajyGWmNFEG6oN2jJVnd50MdDlKVq4g
         wWFSA6J6Rx4gGxFzJMp/eBN+CWfQwkJZMufXMmqd7NVidCuGOGUgAk/eNm3RPBSW7q
         OKTopa2i0UYkya7ar9psETRNezEleawV4Xj0F+84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/57] ASoC: cs42l56: fix DT probe
Date:   Mon, 20 Feb 2023 14:36:12 +0100
Message-Id: <20230220133549.507222807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e18c6da62edc780e4f4f3c9ce07bdacd69505182 ]

While looking through legacy platform data users, I noticed that
the DT probing never uses data from the DT properties, as the
platform_data structure gets overwritten directly after it
is initialized.

There have never been any boards defining the platform_data in
the mainline kernel either, so this driver so far only worked
with patched kernels or with the default values.

For the benefit of possible downstream users, fix the DT probe
by no longer overwriting the data.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230126162203.2986339-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index d41e031931061..3c5ec47a8fe64 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1193,18 +1193,12 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 	if (pdata) {
 		cs42l56->pdata = *pdata;
 	} else {
-		pdata = devm_kzalloc(&i2c_client->dev, sizeof(*pdata),
-				     GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
-
 		if (i2c_client->dev.of_node) {
 			ret = cs42l56_handle_of_data(i2c_client,
 						     &cs42l56->pdata);
 			if (ret != 0)
 				return ret;
 		}
-		cs42l56->pdata = *pdata;
 	}
 
 	if (cs42l56->pdata.gpio_nreset) {
-- 
2.39.0



