Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01154962D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354240AbiFMLby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355064AbiFMLa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FAA2B240;
        Mon, 13 Jun 2022 03:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F77360FDB;
        Mon, 13 Jun 2022 10:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4F4C34114;
        Mon, 13 Jun 2022 10:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117184;
        bh=aAA6hQIpGv3F1Y6sJQtvDmCD4JxsSlbLtBI+wfx5otg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnOsbDk67zSnPWlBM8PzKgwQiEn/S26OC24TecK/F7IsTGWPqqcXsyl4qRaC+ZMLl
         yjkYOE7Vpj1AZjpvMMREicFMKtK56sIowSs0m0Gil5LobDHxR6/Xjzd7J4iMBgkxKY
         Q9QSrlMLuv0LSKm7tNeDFJXuQffpEL6DReZzj4ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Romain Naour <romain.naour@smile.fr>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 316/411] bus: ti-sysc: Fix warnings for unbind for serial
Date:   Mon, 13 Jun 2022 12:09:49 +0200
Message-Id: <20220613094938.216549236@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 469ca73de4ce..44aeceaccfa4 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2724,7 +2724,9 @@ static int sysc_remove(struct platform_device *pdev)
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



