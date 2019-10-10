Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52848D2629
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbfJJJUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUr (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E86E21A4A;
        Thu, 10 Oct 2019 09:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699247;
        bh=tJ7ut830tm4Hr3Xh0fUzLUaVHjxs4ay0mOMQfKCMWqY=;
        h=Subject:To:From:Date:From;
        b=IBZ049itvj7sSjtpyiQXZMwZHr3IIkyGwmVoUi/O8IZBqXdEtj877dJ6Xj1GnGCL1
         ORBlg2ytHyj6UdvL9Q277kF53P/Ef2qL2TaachnxOXkzYUMq8mqlzYrHuTHfzcIlx9
         TC9KaKK7qG0s0ZDWpQ9T7kT/raObsi+Z8yWyYoCs=
Subject: patch "iio: light: fix vcnl4000 devicetree hooks" added to staging-linus
To:     m.felsch@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:08 +0200
Message-ID: <15706992084030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: fix vcnl4000 devicetree hooks

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1436a78c63495dd94c8d4f84a76d78d5317d481b Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Tue, 17 Sep 2019 16:56:36 +0200
Subject: iio: light: fix vcnl4000 devicetree hooks

Since commit ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
the of_match_table is supported but the data shouldn't be a string.
Instead it shall be one of 'enum vcnl4000_device_ids'. Also the matching
logic for the vcnl4020 was wrong. Since the data retrieve mechanism is
still based on the i2c_device_id no failures did appeared till now.

Fixes: ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/vcnl4000.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 51421ac32517..f522cb863e8c 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -398,19 +398,19 @@ static int vcnl4000_probe(struct i2c_client *client,
 static const struct of_device_id vcnl_4000_of_match[] = {
 	{
 		.compatible = "vishay,vcnl4000",
-		.data = "VCNL4000",
+		.data = (void *)VCNL4000,
 	},
 	{
 		.compatible = "vishay,vcnl4010",
-		.data = "VCNL4010",
+		.data = (void *)VCNL4010,
 	},
 	{
-		.compatible = "vishay,vcnl4010",
-		.data = "VCNL4020",
+		.compatible = "vishay,vcnl4020",
+		.data = (void *)VCNL4010,
 	},
 	{
 		.compatible = "vishay,vcnl4200",
-		.data = "VCNL4200",
+		.data = (void *)VCNL4200,
 	},
 	{},
 };
-- 
2.23.0


