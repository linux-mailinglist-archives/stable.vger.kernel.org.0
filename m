Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1162149A543
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370751AbiAYAGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2359448AbiAXXch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343AFC04965E;
        Mon, 24 Jan 2022 11:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F212BB8121A;
        Mon, 24 Jan 2022 19:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4F5C340E5;
        Mon, 24 Jan 2022 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053960;
        bh=l3drqyKm307shc4cfxIPCuI+/kKxaW+ThbT4V2EVyfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LD6YYuZeHxJZ1bzQX7KNpYEgarXGCg42LZI8W64YNu2NxR/jMOFN6SYTbJHrPLvC
         k/3rEy2ZZR8owvLqiYL+qVwq4XRfecXQ8KWac1fRlcgbfyg8OAP+FJfyfvXUpuiKEF
         j2AkHu8Pw6mTw502XKGqI9xiw6ndxpeDW1AbPgmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/563] can: softing: softing_startstop(): fix set but not used variable warning
Date:   Mon, 24 Jan 2022 19:39:58 +0100
Message-Id: <20220124184032.503244774@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 370d988cc529598ebaec6487d4f84c2115dc696b ]

In the function softing_startstop() the variable error_reporting is
assigned but not used. The code that uses this variable is commented
out. Its stated that the functionality is not finally verified.

To fix the warning:

| drivers/net/can/softing/softing_fw.c:424:9: error: variable 'error_reporting' set but not used [-Werror,-Wunused-but-set-variable]

remove the comment, activate the code, but add a "0 &&" to the if
expression and rely on the optimizer rather than the preprocessor to
remove the code.

Link: https://lore.kernel.org/all/20220109103126.1872833-1-mkl@pengutronix.de
Fixes: 03fd3cf5a179 ("can: add driver for Softing card")
Cc: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/softing/softing_fw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/softing/softing_fw.c b/drivers/net/can/softing/softing_fw.c
index ccd649a8e37bd..bad69a4abec10 100644
--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -565,18 +565,19 @@ int softing_startstop(struct net_device *dev, int up)
 		if (ret < 0)
 			goto failed;
 	}
-	/* enable_error_frame */
-	/*
+
+	/* enable_error_frame
+	 *
 	 * Error reporting is switched off at the moment since
 	 * the receiving of them is not yet 100% verified
 	 * This should be enabled sooner or later
-	 *
-	if (error_reporting) {
+	 */
+	if (0 && error_reporting) {
 		ret = softing_fct_cmd(card, 51, "enable_error_frame");
 		if (ret < 0)
 			goto failed;
 	}
-	*/
+
 	/* initialize interface */
 	iowrite16(1, &card->dpram[DPRAM_FCT_PARAM + 2]);
 	iowrite16(1, &card->dpram[DPRAM_FCT_PARAM + 4]);
-- 
2.34.1



