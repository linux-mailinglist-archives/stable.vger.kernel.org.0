Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34A4F3BE9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382175AbiDEMDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357986AbiDEK1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0D7D371F;
        Tue,  5 Apr 2022 03:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47C0CB81B7A;
        Tue,  5 Apr 2022 10:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB20C385A0;
        Tue,  5 Apr 2022 10:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153536;
        bh=1I7qSMB34Xx+T3Vo/9nIFDfP91VQBnF1UrD3/LwdiwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rv7OX3Mzj7/KGsW1HA0ZhBWDbYR9/Ys5+jhCL0b2uUlN2cWtFLCn9/uUUB+ZM6Uxd
         0tGgDzphsJcMe8chuhnFVzvUSR6ThhGrRqTVVIvo5jgxV66RoLguqTDM9XY3axqQ+u
         6S9LDUqA7jZ16Hwg7eGX2KYp0eqiOXGZ0N0Ee7Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/599] ASoC: codecs: wcd934x: Add missing of_node_put() in wcd934x_codec_parse_data
Date:   Tue,  5 Apr 2022 09:29:12 +0200
Message-Id: <20220405070306.517125305@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 9531a631379169d57756b2411178c6238655df88 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.
This is similar to commit 64b92de9603f
("ASoC: wcd9335: fix a leaked reference by adding missing of_node_put")

Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220316083631.14103-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd934x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index f07dea0bc27e..8540ac230d0e 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -5047,6 +5047,7 @@ static int wcd934x_codec_parse_data(struct wcd934x_codec *wcd)
 	}
 
 	wcd->sidev = of_slim_get_device(wcd->sdev->ctrl, ifc_dev_np);
+	of_node_put(ifc_dev_np);
 	if (!wcd->sidev) {
 		dev_err(dev, "Unable to get SLIM Interface device\n");
 		return -EINVAL;
-- 
2.34.1



