Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6555D172169
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgB0Osl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbgB0Nmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:42:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C232468D;
        Thu, 27 Feb 2020 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810955;
        bh=TIjHdADiwkFjXfbpjDNPlSxovxMRHrZrzwi8QVZ2//w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qg3uXXpfP2/yVBYxI42+/Bn0AHbs24il3v9nvoXtTvOUItQNuGIPz8qbM9/GepEAd
         ld6Ype0Ftnx9nGQY2ic/r6YjkRB+ufvlPHG+hJznIkXYNiiHN3Kk4Nc4ntoid8NkG+
         V9wzNTQek8/RwQk3Y6bWLxqeip9zyYX9eO+ua3xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Jones <michael-a1.jones@analog.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 013/113] hwmon: (pmbus/ltc2978) Fix PMBus polling of MFR_COMMON definitions.
Date:   Thu, 27 Feb 2020 14:35:29 +0100
Message-Id: <20200227132213.841275734@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
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
@@ -89,8 +89,8 @@ enum chips { ltc2974, ltc2975, ltc2977,
 
 #define LTC_POLL_TIMEOUT		100	/* in milli-seconds */
 
-#define LTC_NOT_BUSY			BIT(5)
-#define LTC_NOT_PENDING			BIT(4)
+#define LTC_NOT_BUSY			BIT(6)
+#define LTC_NOT_PENDING			BIT(5)
 
 /*
  * LTC2978 clears peak data whenever the CLEAR_FAULTS command is executed, which


