Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2933657B98
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiL1PX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiL1PXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A47C13E18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE3BBB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D5CC433D2;
        Wed, 28 Dec 2022 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240999;
        bh=Hde8ztJAGCanVAl6Rfu/OkUXsy61SOw4nTBUErOeMfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMnZWpIraLHgfbJ/4AkKNBh9eB9iVLVXQ1RqQuOhhzvLxeHDb9GSRbRuzAT5LCtFL
         YdWze0aIHmp7zr3RxYuqLI0K893rx0Yc/hIDixuxfQQfQxNCrBQhJcIpW2N4rzK/y2
         Z5WtoMAIBnVMhT0ah9MC6s8tY1NjY/JunZ8g2d7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0228/1073] media: adv748x: afe: Select input port when initializing AFE
Date:   Wed, 28 Dec 2022 15:30:16 +0100
Message-Id: <20221228144334.217832054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 23ddb85dafefdace1ad79d1a30b0a4e7c4b5cd8d ]

When moving the input selection to adv748x_reset() it was missed that
during probe the device is reset _before_ the initialization and parsing
of DT by the AFE subdevice. This can lead to the wrong input port (in
case it's not port 0) being selected until the device is reset for the
first time.

Fix this by restoring the call to adv748x_afe_s_input() in the AFE
initialization while also keeping it in the adv748x_reset().

Fixes: c30ed81afe89 ("media: adv748x: afe: Select input port when device is reset")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv748x/adv748x-afe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 02eabe10ab97..00095c7762c2 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -521,6 +521,10 @@ int adv748x_afe_init(struct adv748x_afe *afe)
 		}
 	}
 
+	adv748x_afe_s_input(afe, afe->input);
+
+	adv_dbg(state, "AFE Default input set to %d\n", afe->input);
+
 	/* Entity pads and sinks are 0-indexed to match the pads */
 	for (i = ADV748X_AFE_SINK_AIN0; i <= ADV748X_AFE_SINK_AIN7; i++)
 		afe->pads[i].flags = MEDIA_PAD_FL_SINK;
-- 
2.35.1



