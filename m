Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659D0E6853
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbfJ0VWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732094AbfJ0VWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:19 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CEDD21726;
        Sun, 27 Oct 2019 21:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211337;
        bh=bjdEh2/bcBbBN8i1npeg2F+1dvD2NTMkfR4pHea/yaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMagE3kD472ySFDz8fmQ2xOpvWpNTcmoH9IsP6+U6oBE80ewgUA9Q+pfHFFXrYFSQ
         JYVyvH7qa3SNmylBIuebuKwNM3zRpCcasUqhKp5oFcYGEqYp/AJlwCZ2qUXfYdEJrj
         0Sn5wPJTeT8/ZJRXcq23UdLFB9NcT5qLDXqy5Afg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 115/197] Input: da9063 - fix capability and drop KEY_SLEEP
Date:   Sun, 27 Oct 2019 22:00:33 +0100
Message-Id: <20191027203357.950190046@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
@@ -232,10 +232,7 @@ static int da9063_onkey_probe(struct pla
 	onkey->input->phys = onkey->phys;
 	onkey->input->dev.parent = &pdev->dev;
 
-	if (onkey->key_power)
-		input_set_capability(onkey->input, EV_KEY, KEY_POWER);
-
-	input_set_capability(onkey->input, EV_KEY, KEY_SLEEP);
+	input_set_capability(onkey->input, EV_KEY, KEY_POWER);
 
 	INIT_DELAYED_WORK(&onkey->work, da9063_poll_on);
 


