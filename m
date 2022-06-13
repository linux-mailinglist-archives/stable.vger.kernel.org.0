Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9792054976C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353380AbiFMML5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353816AbiFMMJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97997532CE;
        Mon, 13 Jun 2022 04:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F41B80EA7;
        Mon, 13 Jun 2022 11:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61A3C3411C;
        Mon, 13 Jun 2022 11:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118039;
        bh=am04AjD6owRvnb+LGNB0GWp0pAqfo+ZlLBOerBB7Xe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KW0hIOWHec03gc3rHIvevK/IwGzafCPBTk18NnviEXeg+goVBcXnLbNCQZyHAKRKm
         DHP2HbERMQsDXqT5rtpYlUK4ZWFuqhjxF2OgjFjOiEitEKKGrpQsqI8hJdThxdj/Ck
         44DldnC+ijbgw5KlpU/vuV4ToDA5xve5r1Ewi6dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@smile.fr>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/287] bus: ti-sysc: Fix warnings for unbind for serial
Date:   Mon, 13 Jun 2022 12:10:37 +0200
Message-Id: <20220613094930.321973001@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index b6a278183d82..bc274ddb9767 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1801,7 +1801,9 @@ static int sysc_remove(struct platform_device *pdev)
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



