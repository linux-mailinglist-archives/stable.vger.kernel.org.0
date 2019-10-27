Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6086FE691B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbfJ0VeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbfJ0VLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:03 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1893B214AF;
        Sun, 27 Oct 2019 21:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210662;
        bh=lhAvbhfQlTnRyecNnxC92jiplQHtUjhVHPGI6Ea5VTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9+I40WPr+ElI5B84H/9DbhXw0c7hBxarILIDLr2YLBdjn0fmb+STnsFbc6H/zgab
         UUdAyts3K5gKZjzr+KdUIlSOI8lQ6FSsh5rYK1LlgQMO15NlBzJ9jB4cKfin9Dfmsv
         R1Lw3YuSLO4DEelMEM1OXIAGHBrGwfnG9pQOhIIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 091/119] Input: da9063 - fix capability and drop KEY_SLEEP
Date:   Sun, 27 Oct 2019 22:01:08 +0100
Message-Id: <20191027203348.385833199@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit afce285b859cea91c182015fc9858ea58c26cd0e upstream.

Since commit f889beaaab1c ("Input: da9063 - report KEY_POWER instead of
KEY_SLEEP during power key-press") KEY_SLEEP isn't supported anymore. This
caused input device to not generate any events if "dlg,disable-key-power"
is set.

Fix this by unconditionally setting KEY_POWER capability, and not
declaring KEY_SLEEP.

Fixes: f889beaaab1c ("Input: da9063 - report KEY_POWER instead of KEY_SLEEP during power key-press")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/da9063_onkey.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/input/misc/da9063_onkey.c
+++ b/drivers/input/misc/da9063_onkey.c
@@ -248,10 +248,7 @@ static int da9063_onkey_probe(struct pla
 	onkey->input->phys = onkey->phys;
 	onkey->input->dev.parent = &pdev->dev;
 
-	if (onkey->key_power)
-		input_set_capability(onkey->input, EV_KEY, KEY_POWER);
-
-	input_set_capability(onkey->input, EV_KEY, KEY_SLEEP);
+	input_set_capability(onkey->input, EV_KEY, KEY_POWER);
 
 	INIT_DELAYED_WORK(&onkey->work, da9063_poll_on);
 


