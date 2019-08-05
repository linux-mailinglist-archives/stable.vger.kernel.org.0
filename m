Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F1E81B55
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbfHENNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbfHENIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:08:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C815721738;
        Mon,  5 Aug 2019 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010520;
        bh=7J2XoBzKP5scn2LlImnhb61wldOIirXPvxS9/4fXm5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsSJ9DN+KK0TlAhLsFJw9KNM4+IzkFGVhX6XbsnflTpPetGipLsW4fGbOxPVeNwjl
         UfcQygjVjSVWBE3qxjSvf/L7Htvi4Qx5C+1DbECwgQ3LcwL/Jz0vB3Zp1ep9lGtHFi
         S+sRx0pLehiobWzSUz/pCvhiV//EVwmQhoPGJnwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Wu <michael.wu@vatics.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.14 37/53] gpiolib: fix incorrect IRQ requesting of an active-low lineevent
Date:   Mon,  5 Aug 2019 15:03:02 +0200
Message-Id: <20190805124932.242656121@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
References: <20190805124927.973499541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Wu <michael.wu@vatics.com>

commit 223ecaf140b1dd1c1d2a1a1d96281efc5c906984 upstream.

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
Tested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -835,9 +835,11 @@ static int lineevent_create(struct gpio_
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
 	irqflags |= IRQF_SHARED;
 


