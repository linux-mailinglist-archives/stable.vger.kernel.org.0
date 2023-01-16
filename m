Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC3366CBD1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbjAPRSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbjAPRRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B964F530ED;
        Mon, 16 Jan 2023 08:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECBF7B8105D;
        Mon, 16 Jan 2023 16:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B28CC433D2;
        Mon, 16 Jan 2023 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888258;
        bh=JXHgnEsoWZeWPLb0O7tMwk9WlvFs6jzSGMct0JgbqeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLjZgojLbwgFak3UbR92tKCxj+l0SfvDflsHuB7pe/f4HdHVj/vz796RwT36imxSr
         HYUl0ZbKD2/qMBABRtU99vQnOUCuPAt5Af0QPB3UWlCRlp0y7I8gYVJbwayIIKxb2z
         VIOHJcpMncXtf4ies++1dYOP1nZNQ47DKSN1wQyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-pm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Saravana Kannan <saravanak@google.com>,
        Todd Kjos <tkjos@google.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 431/521] driver core: Set deferred_probe_timeout to a longer default if CONFIG_MODULES is set
Date:   Mon, 16 Jan 2023 16:51:33 +0100
Message-Id: <20230116154906.411052637@linuxfoundation.org>
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

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit e2cec7d6853712295cef5377762165a489b2957f ]

When using modules, its common for the modules not to be loaded
until quite late by userland. With the current code,
driver_deferred_probe_check_state() will stop returning
EPROBE_DEFER after late_initcall, which can cause module
dependency resolution to fail after that.

So allow a longer window of 30 seconds (picked somewhat
arbitrarily, but influenced by the similar regulator core
timeout value) in the case where modules are enabled.

Cc: linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Rob Herring <robh@kernel.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: https://lore.kernel.org/r/20200225050828.56458-3-john.stultz@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 63390a416b44..529d324a0f20 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -220,7 +220,16 @@ static int deferred_devs_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
+#ifdef CONFIG_MODULES
+/*
+ * In the case of modules, set the default probe timeout to
+ * 30 seconds to give userland some time to load needed modules
+ */
+static int deferred_probe_timeout = 30;
+#else
+/* In the case of !modules, no probe timeout needed */
 static int deferred_probe_timeout = -1;
+#endif
 static int __init deferred_probe_timeout_setup(char *str)
 {
 	deferred_probe_timeout = simple_strtol(str, NULL, 10);
-- 
2.35.1



