Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787724A43AF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349503AbiAaLWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52602 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349716AbiAaLUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9B661214;
        Mon, 31 Jan 2022 11:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED6FC340E8;
        Mon, 31 Jan 2022 11:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628048;
        bh=7E9ERDVZttx1BEkbi9cB6zU2U3oaHnyBYoXJvVBibGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXVLUQiUcFDjpHvhDNkBgAdS6n8M7m+3OxfM0ULwn13XBhqElDApY+mL2egzXQy4G
         Rdc9yAGtZ9gOh0vgwudub2IOP8W3uJ4m1IvYCTvWUm7eSjEs+tdjnxLYgjOo9B2EiH
         kor1Eubqet/n0uwyPTRSiPeS0kE6jGZG+e0/9xVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.16 109/200] hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649
Date:   Mon, 31 Jan 2022 11:56:12 +0100
Message-Id: <20220131105237.246457324@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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


