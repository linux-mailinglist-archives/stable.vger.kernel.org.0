Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50A66CB5B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjAPRNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbjAPRMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:12:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179191CF54
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6E08B8109B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B40CC433D2;
        Mon, 16 Jan 2023 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887971;
        bh=BSVmVEcOgHV3Ea3iGeO3NCIIf3O1IrZ0Omux/mn7ygc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN/ZkgH79oEvTzIC7iIbX+VRktzp+r+5UaJnmeBceQAVc2+OVMq8gtBtnVru8ZW+m
         KY4JlLnlm/oRn3+WvjvQ9Ajq0iRXtaQvGxprVsIYPd6pn5e1E2/8j/yy/nFjO5/SUq
         I1RjEx7upKml3P4SZZU9QtgPjCvtF1ekgxetgGzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 351/521] ASoC: rt5670: Remove unbalanced pm_runtime_put()
Date:   Mon, 16 Jan 2023 16:50:13 +0100
Message-Id: <20230116154902.838567019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6c900dcc3f7331a67ed29739d74524e428d137fb ]

For some reason rt5670_i2c_probe() does a pm_runtime_put() at the end
of a successful probe. But it has never done a pm_runtime_get() leading
to the following error being logged into dmesg:

 rt5670 i2c-10EC5640:00: Runtime PM usage count underflow!

Fix this by removing the unnecessary pm_runtime_put().

Fixes: 64e89e5f5548 ("ASoC: rt5670: Add runtime PM support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221213123319.11285-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5670.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index 6a2a58e107e3..9dd99d123e44 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -3217,8 +3217,6 @@ static int rt5670_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
-	pm_runtime_put(&i2c->dev);
-
 	return 0;
 err:
 	pm_runtime_disable(&i2c->dev);
-- 
2.35.1



