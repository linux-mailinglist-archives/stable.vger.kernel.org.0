Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9186214EE8
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfEFPGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727507AbfEFOiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AE5B214AE;
        Mon,  6 May 2019 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153482;
        bh=sL3y0IG1KUINbFHeL51POgTm3rfkjbjchIH4oxMEPRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3tUtwo2DFXrFLozGkpfu9R+vxnnrX2sOvxzkedKyyrXVZtoZDliS5tWFpiexWzLe
         ZUUnDsf9ibFo5fYYTfKz/oUaU1aDJB20/VnV8VABLlT/EHCaeTlZOhopOPfUQ3tJIH
         eI4WiwMJtNtP4t2xgr3iUPbw5Azc/mYLHkzjiOgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.0 084/122] Bluetooth: btusb: request wake pin with NOAUTOEN
Date:   Mon,  6 May 2019 16:32:22 +0200
Message-Id: <20190506143102.306608149@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 771acc7e4a6e5dba779cb1a7fd851a164bc81033 upstream.

Badly-designed systems might have (for example) active-high wake pins
that default to high (e.g., because of external pull ups) until they
have an active firmware which starts driving it low.  This can cause an
interrupt storm in the time between request_irq() and disable_irq().

We don't support shared interrupts here, so let's just pre-configure the
interrupt to avoid auto-enabling it.

Fixes: fd913ef7ce61 ("Bluetooth: btusb: Add out-of-band wakeup support")
Fixes: 5364a0b4f4be ("arm64: dts: rockchip: move QCA6174A wakeup pin into its USB node")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2885,6 +2885,7 @@ static int btusb_config_oob_wake(struct
 		return 0;
 	}
 
+	irq_set_status_flags(irq, IRQ_NOAUTOEN);
 	ret = devm_request_irq(&hdev->dev, irq, btusb_oob_wake_handler,
 			       0, "OOB Wake-on-BT", data);
 	if (ret) {
@@ -2899,7 +2900,6 @@ static int btusb_config_oob_wake(struct
 	}
 
 	data->oob_wake_irq = irq;
-	disable_irq(irq);
 	bt_dev_info(hdev, "OOB Wake-on-BT configured at IRQ %u", irq);
 	return 0;
 }


