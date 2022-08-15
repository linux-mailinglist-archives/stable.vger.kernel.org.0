Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA05F5947E3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbiHOXci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345716AbiHOXaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6644BB921;
        Mon, 15 Aug 2022 13:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00B5CB80EA9;
        Mon, 15 Aug 2022 20:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B578C433C1;
        Mon, 15 Aug 2022 20:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594077;
        bh=QZhC4OWnf79y4pgVUj71VLW5Nv7lL1FdigrexeGZP/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uvo6GOLrxntgHwN4H/QgQNsYeTQVQyHzPppVU0Ai6EYsoYi/FEckUj6P8uzQVcjxF
         zW6o1AwwM4ajFerv75H9S1+5EsulIfcw93CYZ7ryNcFUEH4gB+RFRbB2MP7cjIuB8V
         EdxGyNPHFijuZuyKYu9hJG24W5B7OZPNSW9NIDcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0342/1157] drm/bridge: lt9611uxc: Cancel only drivers work
Date:   Mon, 15 Aug 2022 19:54:58 +0200
Message-Id: <20220815180453.375636905@linuxfoundation.org>
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
index 3d62e6bf6892..310b3b194491 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -982,7 +982,7 @@ static int lt9611uxc_remove(struct i2c_client *client)
 	struct lt9611uxc *lt9611uxc = i2c_get_clientdata(client);
 
 	disable_irq(client->irq);
-	flush_scheduled_work();
+	cancel_work_sync(&lt9611uxc->work);
 	lt9611uxc_audio_exit(lt9611uxc);
 	drm_bridge_remove(&lt9611uxc->bridge);
 
-- 
2.35.1



