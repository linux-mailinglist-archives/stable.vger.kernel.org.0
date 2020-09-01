Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE91259678
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIAQCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbgIAPnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A9E2064B;
        Tue,  1 Sep 2020 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974991;
        bh=h68ZEXTEgHOBmJRPT4W4AKNXN5F2l6HFFOywB0QBYrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVXP+rFgGbvpzeHPpjSwMC+dOc+4P2FztW4rCbbo/IgLhQwNEYM2+Dw3ujLVWRCjM
         Dlrug6QSU3eAn0HLQK9g7vjlqPOn95ILqwrcbCpOvcER3byDCLxHG279Vu9s12q4or
         RzUODZMYglBcjhlw74jbON0+r9tq1+4naTwSqfdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.8 167/255] hwmon: (gsc-hwmon) Scale temperature to millidegrees
Date:   Tue,  1 Sep 2020 17:10:23 +0200
Message-Id: <20200901151008.696784793@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

commit c1ae18d313e24bc7833e1749dd36dba5d47f259c upstream.

The GSC registers report temperature in decidegrees celcius so we
need to scale it to represent the hwmon sysfs API of millidegrees.

Cc: stable@vger.kernel.org
Fixes: 3bce5377ef66 ("hwmon: Add Gateworks System Controller support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Link: https://lore.kernel.org/r/1598548824-16898-1-git-send-email-tharvey@gateworks.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/gsc-hwmon.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/gsc-hwmon.c
+++ b/drivers/hwmon/gsc-hwmon.c
@@ -172,6 +172,7 @@ gsc_hwmon_read(struct device *dev, enum
 	case mode_temperature:
 		if (tmp > 0x8000)
 			tmp -= 0xffff;
+		tmp *= 100; /* convert to millidegrees celsius */
 		break;
 	case mode_voltage_raw:
 		tmp = clamp_val(tmp, 0, BIT(GSC_HWMON_RESOLUTION));


