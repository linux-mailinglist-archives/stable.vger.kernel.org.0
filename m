Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD456C1930
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbjCTPbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjCTPbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB833CCA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A88A614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D62C433D2;
        Mon, 20 Mar 2023 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325816;
        bh=1u7MbV6dNGB1fbf72j2zhnJn3q0+hQss08NcFyiDhmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b44qMNgaFDsJPWdoG1Wud9yPwj9/dyGnVMUk4MBSmHxLh+BKIXK1H22jxxph3V/xa
         8lBzK4f9VoLKGqYashTD3G1wUQDDwm+AZ2c/kJfsrAVxojGcWvwd9BJc1rePkfC/1N
         ZjcTd4Nd9nx9GNdXt2M6XTBB5wzp2h9wrTJa1Qd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 106/211] hwmon: (ltc2992) Set `can_sleep` flag for GPIO chip
Date:   Mon, 20 Mar 2023 15:54:01 +0100
Message-Id: <20230320145517.719236889@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit ab00709310eedcd8dae0df1f66d332f9bc64c99e ]

The ltc2992 drivers uses a mutex and I2C bus access in its GPIO chip `set`
and `get` implementation. This means these functions can sleep and the GPIO
chip should set the `can_sleep` property to true.

This will ensure that a warning is printed when trying to set or get the
GPIO value from a context that potentially can't sleep.

Fixes: 9ca26df1ba25 ("hwmon: (ltc2992) Add support for GPIOs.")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230314093146.2443845-2-lars@metafoo.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2992.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ltc2992.c b/drivers/hwmon/ltc2992.c
index 88514152d9306..69341de397cb9 100644
--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -323,6 +323,7 @@ static int ltc2992_config_gpio(struct ltc2992_state *st)
 	st->gc.label = name;
 	st->gc.parent = &st->client->dev;
 	st->gc.owner = THIS_MODULE;
+	st->gc.can_sleep = true;
 	st->gc.base = -1;
 	st->gc.names = st->gpio_names;
 	st->gc.ngpio = ARRAY_SIZE(st->gpio_names);
-- 
2.39.2



