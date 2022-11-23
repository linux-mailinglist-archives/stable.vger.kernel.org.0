Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6EB6357EC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiKWJsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiKWJsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:48:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFF01181F2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:44:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4862161B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34137C433D7;
        Wed, 23 Nov 2022 09:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196698;
        bh=zlrVVZ1NsxJDlfGE4DmZDf4BrpLtn+E+pd/O+s4YzOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYpbaXOUD5OzpUiM4sqdlAq0oWzYZyF4oa5lZhpGrMQ45ZSKG3aYUrdJFnHgaVrmH
         NqRmJlGO4Yvfkk1gazqPDhEAI52ifuT3lib5UX4IaCFwxbkiDi6dwnIbjJ2C5L5xIt
         4LWU9gYxxplUOCQaC9p9BrKxce3mlY6mXwTZA/IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 098/314] serial: 8250: omap: Flush PM QOS work on remove
Date:   Wed, 23 Nov 2022 09:49:03 +0100
Message-Id: <20221123084629.949600634@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit d0b68629bd2fb61e0171a62f2e8da3db322f5cf6 ]

Rebinding 8250_omap in a loop will at some point produce a warning for
kernel/power/qos.c:296 cpu_latency_qos_update_request() with error
"cpu_latency_qos_update_request called for unknown object". Let's flush
the possibly pending PM QOS work scheduled from omap8250_runtime_suspend()
before we disable runtime PM.

Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221028110044.54719-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 3ba1526ccd20..b96fbf8d31df 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1469,6 +1469,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
 	serial8250_unregister_port(priv->line);
 	cpu_latency_qos_remove_request(&priv->pm_qos_request);
-- 
2.35.1



