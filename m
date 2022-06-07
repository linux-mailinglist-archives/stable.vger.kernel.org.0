Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0723540AE3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbiFGSYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350790AbiFGSTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:19:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17E36FA21;
        Tue,  7 Jun 2022 10:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DAEC615B1;
        Tue,  7 Jun 2022 17:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A0FC36B01;
        Tue,  7 Jun 2022 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624421;
        bh=QZsirAHLXyzJVrTkY/suxsZZZSl9IHSAJLFc0FhppEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0SX4ubd7xEcXQAwwqKGK6pb/q1qytmY/AzoND14ezTRCPu6e9aSQBxHLcMrErHlm
         6MBPHxsJB3uM623mNo4mSqmzgKupng0K4Mf6vzcrqyGe8artOajDwILxVumg1ENzT5
         BX8sh3DNRkBJkIQ4FguHhDjKxGsYBOE1//O+Zlgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/667] media: atmel: atmel-isc: Fix PM disable depth imbalance in atmel_isc_probe
Date:   Tue,  7 Jun 2022 18:59:47 +0200
Message-Id: <20220607164944.428422300@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 395829c61a196a0821a703a49c4db3ac51daff73 ]

The pm_runtime_enable will decrease power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().

Fixes: 0a0e265515db ("media: atmel: atmel-isc: split driver into driver base and isc")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-sama5d2-isc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index e29a9193bac8..c8ed9315ef31 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -537,7 +537,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(isc->ispck);
 	if (ret) {
 		dev_err(dev, "failed to enable ispck: %d\n", ret);
-		goto cleanup_subdev;
+		goto disable_pm;
 	}
 
 	/* ispck should be greater or equal to hclock */
@@ -555,6 +555,9 @@ static int atmel_isc_probe(struct platform_device *pdev)
 unprepare_clk:
 	clk_disable_unprepare(isc->ispck);
 
+disable_pm:
+	pm_runtime_disable(dev);
+
 cleanup_subdev:
 	isc_subdev_cleanup(isc);
 
-- 
2.35.1



