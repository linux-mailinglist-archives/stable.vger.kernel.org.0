Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC6549517
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbiFMMbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353230AbiFMM1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:27:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CCD326FF;
        Mon, 13 Jun 2022 04:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CC83614BF;
        Mon, 13 Jun 2022 11:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9971C34114;
        Mon, 13 Jun 2022 11:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118345;
        bh=EUTDtY3A60DHC0r/RLOq13/jsTP5MMXGOG1l/cmd1y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8L/A+nVfT6oYRg2CP+sOrMhH0Q0Ym+tQ02C5xu9GVkOV9g+NsE2uf3iHagjcWr1X
         +M28JfF7OD5u6a/XH4OXG9f3Dlj5f47l6fN12MOSuWKXKP0jPAy9H4/y+QNX577UFO
         /s2csxjtWQvkklLUEihjKXW+nj22JwShFlRsbvhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@smile.fr>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/172] bus: ti-sysc: Fix warnings for unbind for serial
Date:   Mon, 13 Jun 2022 12:10:02 +0200
Message-Id: <20220613094900.470349013@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit c337125b8834f9719dfda0e40b25eaa266f1b8cf ]

We can get "failed to disable" clock_unprepare warnings on unbind at least
for the serial console device if the unbind is done before the device has
been idled.

As some devices are using deferred idle, we must check the status for
pending idle work to idle the device.

Fixes: 76f0f772e469 ("bus: ti-sysc: Improve handling for no-reset-on-init and no-idle-on-init")
Cc: Romain Naour <romain.naour@smile.fr>
Reviewed-by: Romain Naour <romain.naour@smile.fr>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220512053021.61650-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index ac559c262033..4ee20be76508 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3291,7 +3291,9 @@ static int sysc_remove(struct platform_device *pdev)
 	struct sysc *ddata = platform_get_drvdata(pdev);
 	int error;
 
-	cancel_delayed_work_sync(&ddata->idle_work);
+	/* Device can still be enabled, see deferred idle quirk in probe */
+	if (cancel_delayed_work_sync(&ddata->idle_work))
+		ti_sysc_idle(&ddata->idle_work.work);
 
 	error = pm_runtime_get_sync(ddata->dev);
 	if (error < 0) {
-- 
2.35.1



