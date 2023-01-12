Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23F266743E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjALOEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjALODt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:03:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EFB517FF
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:03:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B476EB81E66
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DB1C433F0;
        Thu, 12 Jan 2023 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532225;
        bh=wkAQ1xibcMr0ugYAPfpVyg0mwskgwMgFNCWDHl7RLzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSajpjP5TO+sUodS4f9wJmkjVCUFvNbKFZPe/wgrPd38RP4FtNahhFkihuISRNVZk
         fn1D8f78rKRDCh4ll9VJrORiQlmWOZVIQKJRSr0STPNvt1/udwiJgb+SHC2Xp9Zv5n
         ofDcrKWhnEktioPR0rdFNfIw5kqeLcZGr/Wj48LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/783] PM: runtime: Improve path in rpm_idle() when no callback
Date:   Thu, 12 Jan 2023 14:46:47 +0100
Message-Id: <20230112135528.399632756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 5a2bd1b1c64e1ac5627db3767ac465f18606315c ]

When pm_runtime_no_callbacks() has been called for a struct device to set
the dev->power.no_callbacks flag for it, it enables rpm_idle() to take a
slightly quicker path by assuming that a ->runtime_idle() callback would
have returned 0 to indicate success.

A device that does not have the dev->power.no_callbacks flag set for it,
may still be missing a corresponding ->runtime_idle() callback, in which
case the slower path in rpm_idle() is taken. Let's improve the behaviour
for this case, by aligning code to the quicker path.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: bc80c2e438dc ("PM: runtime: Do not call __rpm_callback() from rpm_idle()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 835a39e84c1d..532d910fe1cf 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -464,7 +464,10 @@ static int rpm_idle(struct device *dev, int rpmflags)
 	/* Pending requests need to be canceled. */
 	dev->power.request = RPM_REQ_NONE;
 
-	if (dev->power.no_callbacks)
+	callback = RPM_GET_CALLBACK(dev, runtime_idle);
+
+	/* If no callback assume success. */
+	if (!callback || dev->power.no_callbacks)
 		goto out;
 
 	/* Carry out an asynchronous or a synchronous idle notification. */
@@ -480,10 +483,7 @@ static int rpm_idle(struct device *dev, int rpmflags)
 
 	dev->power.idle_notification = true;
 
-	callback = RPM_GET_CALLBACK(dev, runtime_idle);
-
-	if (callback)
-		retval = __rpm_callback(callback, dev);
+	retval = __rpm_callback(callback, dev);
 
 	dev->power.idle_notification = false;
 	wake_up_all(&dev->power.wait_queue);
-- 
2.35.1



