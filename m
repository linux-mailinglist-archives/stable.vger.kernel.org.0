Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBA0528FB2
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiEPUIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350163AbiEPUAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC7946644;
        Mon, 16 May 2022 12:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A5A760A14;
        Mon, 16 May 2022 19:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113D9C36AE2;
        Mon, 16 May 2022 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730868;
        bh=lEaxH+Zrm3LXE0KrWgkFL430Y9ob1JUFCC0MSBkH42Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMfEEQkwaho0vbklZkbLzK5lG6IzYAFktuFh4wp2IvhVgOdUw+bRlzziHmXsgN/QQ
         lbEU8CWpI23aZD30ibZFb24Gn8N/ieZVFuUcWZ6sj8Al+VFMw92g3KgbFARUzTGryk
         XK+MJdTrfAdL3iMaF/lgGShGu6lpRrpxrAWN/H34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Camel Guo <camel.guo@axis.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 003/114] hwmon: (tmp401) Add OF device ID table
Date:   Mon, 16 May 2022 21:35:37 +0200
Message-Id: <20220516193625.592158778@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Camel Guo <camel.guo@axis.com>

[ Upstream commit 3481551f035725fdc46885425eac3ef9b58ae7b7 ]

This driver doesn't have of_match_table. This makes the kernel module
tmp401.ko lack alias patterns (e.g: of:N*T*Cti,tmp411) to match DT node
of the supported devices hence this kernel module will not be
automatically loaded.

After adding of_match_table to this driver, the folllowing alias will be
added into tmp401.ko.
$ modinfo drivers/hwmon/tmp401.ko
filename: drivers/hwmon/tmp401.ko
......
author:         Hans de Goede <hdegoede@redhat.com>
alias:          of:N*T*Cti,tmp435C*
alias:          of:N*T*Cti,tmp435
alias:          of:N*T*Cti,tmp432C*
alias:          of:N*T*Cti,tmp432
alias:          of:N*T*Cti,tmp431C*
alias:          of:N*T*Cti,tmp431
alias:          of:N*T*Cti,tmp411C*
alias:          of:N*T*Cti,tmp411
alias:          of:N*T*Cti,tmp401C*
alias:          of:N*T*Cti,tmp401
......

Fixes: af503716ac14 ("i2c: core: report OF style module alias for devices registered via OF")
Signed-off-by: Camel Guo <camel.guo@axis.com>
Link: https://lore.kernel.org/r/20220503114333.456476-1-camel.guo@axis.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp401.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index b86d9df7105d..52c9e7d3f2ae 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -708,10 +708,21 @@ static int tmp401_probe(struct i2c_client *client)
 	return 0;
 }
 
+static const struct of_device_id __maybe_unused tmp4xx_of_match[] = {
+	{ .compatible = "ti,tmp401", },
+	{ .compatible = "ti,tmp411", },
+	{ .compatible = "ti,tmp431", },
+	{ .compatible = "ti,tmp432", },
+	{ .compatible = "ti,tmp435", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tmp4xx_of_match);
+
 static struct i2c_driver tmp401_driver = {
 	.class		= I2C_CLASS_HWMON,
 	.driver = {
 		.name	= "tmp401",
+		.of_match_table = of_match_ptr(tmp4xx_of_match),
 	},
 	.probe_new	= tmp401_probe,
 	.id_table	= tmp401_id,
-- 
2.35.1



