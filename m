Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7861A58
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 07:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbfGHFjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 01:39:13 -0400
Received: from mail.vivotek.com ([60.248.39.150]:52004 "EHLO mail.vivotek.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbfGHFjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 01:39:13 -0400
X-Greylist: delayed 935 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2019 01:39:12 EDT
Received: from pps.filterd (vivotekpps.vivotek.com [127.0.0.1])
        by vivotekpps.vivotek.com (8.16.0.22/8.16.0.22) with SMTP id x685MZlM025500;
        Mon, 8 Jul 2019 13:23:23 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivotek.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=dkim;
 bh=zi7h8BLqmWEo/Z3srkGQhYbbOAKvfqg0vBi17vSUil8=;
 b=Adx0F6ezhMxVIIptEfA5rPG46jj1FPYfXb8sTpCLtLqNFH4pMGuxWVUGLzIjq4Gni2cD
 2G7eBWc/88AtkAruGc6iLIU/FuRMiULHvKwvzmtYSu21qjn3y/krSsrQdDazdcTUB3+w
 hRTXg9Tf47ZsCI665I+UTIYi9e7/veLmD3w= 
Received: from cas01.vivotek.tw ([192.168.0.58])
        by vivotekpps.vivotek.com with ESMTP id 2tkyevr0by-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 08 Jul 2019 13:23:23 +0800
Received: from localhost.localdomain (192.168.17.134) by CAS01.vivotek.tw
 (192.168.0.58) with Microsoft SMTP Server (TLS) id 14.3.319.2; Mon, 8 Jul
 2019 13:23:22 +0800
From:   Michael Wu <michael.wu@vatics.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <morgan.chang@vatics.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] gpiolib: fix incorrect IRQ requesting of an active-low lineevent
Date:   Mon, 8 Jul 2019 13:23:08 +0800
Message-ID: <20190708052308.27802-1-michael.wu@vatics.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.17.134]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_01:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a pin is active-low, logical trigger edge should be inverted to match
the same interrupt opportunity.

For example, a button pushed triggers falling edge in ACTIVE_HIGH case; in
ACTIVE_LOW case, the button pushed triggers rising edge. For user space the
IRQ requesting doesn't need to do any modification except to configuring
GPIOHANDLE_REQUEST_ACTIVE_LOW.

For example, we want to catch the event when the button is pushed. The
button on the original board drives level to be low when it is pushed, and
drives level to be high when it is released.

In user space we can do:

	req.handleflags = GPIOHANDLE_REQUEST_INPUT;
	req.eventflags = GPIOEVENT_REQUEST_FALLING_EDGE;

	while (1) {
		read(fd, &dat, sizeof(dat));
		if (dat.id == GPIOEVENT_EVENT_FALLING_EDGE)
			printf("button pushed\n");
	}

Run the same logic on another board which the polarity of the button is
inverted; it drives level to be high when pushed, and level to be low when
released. For this inversion we add flag GPIOHANDLE_REQUEST_ACTIVE_LOW:

	req.handleflags = GPIOHANDLE_REQUEST_INPUT |
		GPIOHANDLE_REQUEST_ACTIVE_LOW;
	req.eventflags = GPIOEVENT_REQUEST_FALLING_EDGE;

At the result, there are no any events caught when the button is pushed.
By the way, button releasing will emit a "falling" event. The timing of
"falling" catching is not expected.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Wu <michael.wu@vatics.com>
---
Changes from v1:
- Correct undeclared 'IRQ_TRIGGER_RISING'
- Add an example to descibe the issue
---
 drivers/gpio/gpiolib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e013d417a936..9c9597f929d7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -956,9 +956,11 @@ static int lineevent_create(struct gpio_device *gdev, void __user *ip)
 	}
 
 	if (eflags & GPIOEVENT_REQUEST_RISING_EDGE)
-		irqflags |= IRQF_TRIGGER_RISING;
+		irqflags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
+			IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
 	if (eflags & GPIOEVENT_REQUEST_FALLING_EDGE)
-		irqflags |= IRQF_TRIGGER_FALLING;
+		irqflags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
+			IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
 	irqflags |= IRQF_ONESHOT;
 
 	INIT_KFIFO(le->events);
-- 
2.17.1

