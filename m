Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7673110BC59
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfK0VI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732422AbfK0VI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E107C2154A;
        Wed, 27 Nov 2019 21:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888936;
        bh=IleI4WBlvw0MbTkV3loKafslw9g3LQhrhlmA3V+horw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDcd4bDXrwyfnJwqpWL+7wc+UN+o7ikMYMdJcD95Gw0xIOKuNyDXf2C4qRde2k+0H
         nWGg9NlyVr9A9NPm+bV4tmgTNXdKr/EXxY9Dg0IWTrii8TSOb1El3Xyapj1RW1rJx8
         Q93XmuHPsvNHXhuSbCT75iNnOsn6XPoPzz/bO/Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.3 20/95] gpio: bd70528: Use correct unit for debounce times
Date:   Wed, 27 Nov 2019 21:31:37 +0100
Message-Id: <20191127202850.450458548@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit f88c117b6d6d7e96557b6ee143b26b550fc51076 upstream.

The debounce time passed to gpiod_set_debounce() is specified in
microseconds, so make sure to use the correct unit when computing the
register values, which denote delays in milliseconds.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: <stable@vger.kernel.org>
Fixes: 18bc64b3aebf ("gpio: Initial support for ROHM bd70528 GPIO block")
[Bartosz: fixed a typo in commit message]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-bd70528.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-bd70528.c
+++ b/drivers/gpio/gpio-bd70528.c
@@ -25,13 +25,13 @@ static int bd70528_set_debounce(struct b
 	case 0:
 		val = BD70528_DEBOUNCE_DISABLE;
 		break;
-	case 1 ... 15:
+	case 1 ... 15000:
 		val = BD70528_DEBOUNCE_15MS;
 		break;
-	case 16 ... 30:
+	case 15001 ... 30000:
 		val = BD70528_DEBOUNCE_30MS;
 		break;
-	case 31 ... 50:
+	case 30001 ... 50000:
 		val = BD70528_DEBOUNCE_50MS;
 		break;
 	default:


