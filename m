Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5B59367B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbiHOSnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244104AbiHOSmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872D42F3BD;
        Mon, 15 Aug 2022 11:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32480B81071;
        Mon, 15 Aug 2022 18:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A9C433D6;
        Mon, 15 Aug 2022 18:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587956;
        bh=Z8QdnvFIXKN5jemo17wpQnROqTwiw5XqL1IzUTYZcv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smrvQfbcCngFEN8JdM0cj6iF/AxwH9QGpbBCga9pUZX7SYOob6f07BhFl5enmkwyp
         j7tHUO57tycr96fmIgBNfa3U8YIKcUskOOFpumLCSWxGQtmHTNlT7ade0lbJYk0+PV
         tC/GIHvoZUQpIw8hzl2TxGCDNGq+4s7zQ2QHpKug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/779] drm/bridge: lt9611uxc: Cancel only drivers work
Date:   Mon, 15 Aug 2022 19:58:13 +0200
Message-Id: <20220815180347.989861665@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit dfa687bffc8a4a21ed929c7dececf01b8f1f52ee ]

During device remove care needs to be taken that no work is pending
before it removes the underlying DRM bridge etc, but this can be done on
the specific work rather than waiting for the flush of the system-wide
workqueue.

Fixes: bc6fa8676ebb ("drm/bridge/lontium-lt9611uxc: move HPD notification out of IRQ handler")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220601233818.1877963-1-bjorn.andersson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index 010657ea7af7..c4454d0f6cad 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -997,7 +997,7 @@ static int lt9611uxc_remove(struct i2c_client *client)
 	struct lt9611uxc *lt9611uxc = i2c_get_clientdata(client);
 
 	disable_irq(client->irq);
-	flush_scheduled_work();
+	cancel_work_sync(&lt9611uxc->work);
 	lt9611uxc_audio_exit(lt9611uxc);
 	drm_bridge_remove(&lt9611uxc->bridge);
 
-- 
2.35.1



