Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04644A41D4
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358786AbiAaLGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359118AbiAaLEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:04:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B41EC0613A4;
        Mon, 31 Jan 2022 03:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECC0AB82A69;
        Mon, 31 Jan 2022 11:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0809AC340E8;
        Mon, 31 Jan 2022 11:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627035;
        bh=7E9ERDVZttx1BEkbi9cB6zU2U3oaHnyBYoXJvVBibGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPNCP81vSuCz/XLEFU5+4FtLI3B9Qtl6NTO/RthxvP9HovuogNZ/Lv6Hb4hP5KtEg
         Rxursf1dPB2FjT9X87pUP/QX7T1pytUjlAszfUm1VMIaF6YtJPflj16DKTr8Eo0iyN
         qFNfK40YGVjnt77sXbuU60Bpt2IhneY7861TD5MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 054/100] hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649
Date:   Mon, 31 Jan 2022 11:56:15 +0100
Message-Id: <20220131105222.254828909@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit f614629f9c1080dcc844a8430e3fb4c37ebbf05d upstream.

Experiments with MAX6646 and MAX6648 show that the alert function of those
chips is broken, similar to other chips supported by the lm90 driver.
Mark it accordingly.

Fixes: 4667bcb8d8fc ("hwmon: (lm90) Introduce chip parameter structure")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/lm90.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -394,7 +394,7 @@ static const struct lm90_params lm90_par
 		.max_convrate = 9,
 	},
 	[max6646] = {
-		.flags = LM90_HAVE_CRIT,
+		.flags = LM90_HAVE_CRIT | LM90_HAVE_BROKEN_ALERT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,


