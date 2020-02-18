Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40E0163209
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgBRUEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgBRUC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF07021D56;
        Tue, 18 Feb 2020 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056179;
        bh=us2hgAvUzqAPptOOCH7doagG3AK8HtWXYp9L9PEzMC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xw4ztxXImCygasJii6jBuNGtrMzAFMoEFjRWu6Rs67eiaaWtZIvIg82iF2Wm7pmUH
         jEZkEaerLVilF8H7ZgertAUV8sn4M0Ljh329oqHOr6eDcWKUaFkbA4EZdqkwdhQdqL
         mIcRD5Or3FCZh6HGM4MM3EDSN3huPt5u0o+GElMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Jones <michael-a1.jones@analog.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.5 64/80] hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.
Date:   Tue, 18 Feb 2020 20:55:25 +0100
Message-Id: <20200218190438.150862023@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Jones <michael-a1.jones@analog.com>

commit cf2b012c90e74e85d8aea7d67e48868069cfee0c upstream.

Change 21537dc driver PMBus polling of MFR_COMMON from bits 5/4 to
bits 6/5. This fixs a LTC297X family bug where polling always returns
not busy even when the part is busy. This fixes a LTC388X and
LTM467X bug where polling used PEND and NOT_IN_TRANS, and BUSY was
not polled, which can lead to NACKing of commands. LTC388X and
LTM467X modules now poll BUSY and PEND, increasing reliability by
eliminating NACKing of commands.

Signed-off-by: Mike Jones <michael-a1.jones@analog.com>
Link: https://lore.kernel.org/r/1580234400-2829-2-git-send-email-michael-a1.jones@analog.com
Fixes: e04d1ce9bbb49 ("hwmon: (ltc2978) Add polling for chips requiring it")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/ltc2978.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -82,8 +82,8 @@ enum chips { ltc2974, ltc2975, ltc2977,
 
 #define LTC_POLL_TIMEOUT		100	/* in milli-seconds */
 
-#define LTC_NOT_BUSY			BIT(5)
-#define LTC_NOT_PENDING			BIT(4)
+#define LTC_NOT_BUSY			BIT(6)
+#define LTC_NOT_PENDING			BIT(5)
 
 /*
  * LTC2978 clears peak data whenever the CLEAR_FAULTS command is executed, which


