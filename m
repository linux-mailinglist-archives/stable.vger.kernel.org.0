Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00ADC65B26A
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 13:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjABMyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 07:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbjABMyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 07:54:10 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FA52EE
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 04:54:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fy8so2506676ejc.13
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 04:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4mSpRdBbR8hRsjiFVakEqY6OCTQghFDsF57WE7uaZ24=;
        b=ftNK/aNTJUYoLnNPnZtpYA0c2auYvuuZKBly8Ot7SG7yW80AnySckkTePJ4xHSKbVs
         qGWNQ+TBR+xT8+ytjem9zJrRHsBevryPUeqG17zBdheg1DsgTDoYTELa/DS0kb6V6qhR
         71JZNOJMfUTcRck6vbmmnqo392zr6FgeXCnOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mSpRdBbR8hRsjiFVakEqY6OCTQghFDsF57WE7uaZ24=;
        b=kOUdth+hJxND1z3T7CUPDYIuqXjfX9+m5AhU6nFTWTU3dYxDHqy0igi2QSh3+HmgfT
         p6jD3T/ggL9Mv+3pJ/Cu1l8hm/T5Fu4aPeLILBy1fIbihVLLJp/64FwecOw8Re7bUw8A
         fgxXnkEj62IxOxP4ZrHnyZxNJA4bmTGhsqif3sTeyuSrFaF4gfsL9OEc/c/VQVp2UvGq
         o2jCOR7QVVuMgPO7H+IGy63kppeTr8ol1kgqFMzipnSDkb0uEp2PT9kbr6wjLo6u52dy
         zHM1aL5XqCLAS+ZLre91vO2YtPXMb49Q1C6QdsBrpEQ4uD03xwLW3V/cra5HQvJQi3jV
         eOeg==
X-Gm-Message-State: AFqh2koQXr635yqs1hKqlhRk/9esxbFP4OEkxvWVlh2jnbyNYLiuIcV4
        yDdm7kzdzlbPmLMRWg3Hblmm4Psjj68ayo43s4o=
X-Google-Smtp-Source: AMrXdXtKnal3J9pm26arZI9MbJIEvGdKx3JHk0FBnpKk8LqbC79A6lGLoOjRyMQqd+u8Jb8OqFug2w==
X-Received: by 2002:a17:906:9f07:b0:7c1:6f0a:a2cf with SMTP id fy7-20020a1709069f0700b007c16f0aa2cfmr35989436ejc.32.1672664047325;
        Mon, 02 Jan 2023 04:54:07 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:6ef6:ea10:76ec:977f])
        by smtp.gmail.com with ESMTPSA id j15-20020a170906094f00b007add28659b0sm13205598ejd.140.2023.01.02.04.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 04:54:06 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 02 Jan 2023 13:53:38 +0100
Subject: [PATCH v5] media: uvcvideo: Fix race condition with usb_kill_urb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v5-0-3db3933d1608@chromium.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Max Staudt <mstaudt@google.com>
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=5506; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=+NHyWPvCyiTeSkvSubZaZ/Q7vNEi0zyCacfqmuUFlec=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjstPpb14iWK6RcBI4U/PFcjqha1VTQAciMfENYSVQ
 E6oV2xWJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY7LT6QAKCRDRN9E+zzrEiJciD/
 0QhKqGkYR0UyIX7FhHkAGoH2TSg5zA4GQlTlCH0inYvovIfE9a5nql/WSl+nfDPU0UOiAJyZQhx9EI
 Gwze+7gey1+WYXHo8oexhS1zHupNXWoaGwaEH1Om/HAU6/PGYOon81TxK2bXf+rM7JP2/J8tn++S07
 0bTPCCHDx2cJPvIwgkUqXM1qzPZdwXnEshv9A/jgK+1A9MOY92TbF5D2mR7cakcOLM5XAonXViFxh2
 Rxehg952173WD5jLzxamdCB4WOPXIp7Pa/P2PTb0gQjUg6VYbc+Oi0SX11PE4sGC1TRl212XzyeaxL
 uUlxbbdWnsZpa/qb87rDF0isbHmFuySVBTn51CmAxiJ2dNw/sqhqkiec1O0FOnP2NpIWkytOkttlSu
 Vm8OpvXvAJZvAm58PcddIrO3qURhQw9HLFl18OzTOxu+KsQicyi3WvVuQNzZLQYcRrEpAnszDliUL0
 +KE09fP90LTCQ5XkYTSgTONgDX7VT6rLpnQVfOMxG4QOLq3ITax+hChTLBcUDXhHgfQXFV7giThyO9
 HQo3G8IPLQ0jMlhmLioRuFDRsynLnYoluMJ90rhHZMkGhyX/7A49d/qCEp1dZk5qavxu5CPfdo7xTy
 pLt7dpATJQ9o2TY3vjqEqDbvzW8IVLjC0pG8HCjaI6MWGOlbsFJkjQPzzihg==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

usb_kill_urb warranties that all the handlers are finished when it
returns, but does not protect against threads that might be handling
asynchronously the urb.

For UVC, the function uvc_ctrl_status_event_async() takes care of
control changes asynchronously.

 If the code is executed in the following order:

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
uvc_ctrl_status_event_work()
					uvc_status_start() -> FAIL

Then uvc_status_start will keep failing and this error will be shown:

<4>[    5.540139] URB 0000000000000000 submitted while active
drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528

Let's improve the current situation, by not re-submiting the urb if
we are stopping the status event. Also process the queued work
(if any) during stop.

CPU 0					CPU 1
===== 					=====
uvc_status_complete()
					uvc_status_stop()
					uvc_status_start()
uvc_ctrl_status_event_work() -> FAIL

Hopefully, with the usb layer protection this should be enough to cover
all the cases.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Reviewed-by: Yunke Cao <yunkec@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
uvc: Fix race condition on uvc

Make sure that all the async work is finished when we stop the status urb.

To: Yunke Cao <yunkec@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Max Staudt <mstaudt@google.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes in v5:
- atomic_t do not impose barriers, use smp_mb() instead. (Thanks Laurent)
- Add an extra cancel_work_sync().
- Link to v4: https://lore.kernel.org/r/20221212-uvc-race-v4-0-38d7075b03f5@chromium.org

Changes in v4:
- Replace bool with atomic_t to avoid compiler reordering.
- First complete the async work and then kill the urb to avoid race (Thanks Laurent!)
- Link to v3: https://lore.kernel.org/r/20221212-uvc-race-v3-0-954efc752c9a@chromium.org

Changes in v3:
- Remove the patch for dev->status, makes more sense in another series, and makes
  the zero day less nervous.
- Update reviewed-by (thanks Yunke!).
- Link to v2: https://lore.kernel.org/r/20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org

Changes in v2:
- Add a patch for not kalloc dev->status
- Redo the logic mechanism, so it also works with suspend (Thanks Yunke!)
- Link to v1: https://lore.kernel.org/r/20221212-uvc-race-v1-0-c52e1783c31d@chromium.org
---
 drivers/media/usb/uvc/uvc_ctrl.c   |  3 +++
 drivers/media/usb/uvc/uvc_status.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 40 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c95a2229f4fa..5160facc8e20 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	if (dev->flush_status)
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 7518ffce22ed..5911e63776e1 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -309,5 +310,40 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/* From this point, the status urb is not re-queued */
+	dev->flush_status = 1;
+	/*
+	 * Make sure that the other CPUs are aware of the new value of
+	 * flush_status.
+	 */
+	smp_mb();
+
+	/* If there is any status event on the queue, process it. */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/* Kill the urb. */
 	usb_kill_urb(dev->int_urb);
+
+	/*
+	 * If an status event was queued between cancel_work_sync() and
+	 * usb_kill_urb(), process it.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/*
+	 * From this point, there are no events on the queue and the status urb
+	 * is dead, this is, no events will be queued until uvc_status_start()
+	 * is called.
+	 */
+	dev->flush_status = 0;
+	/*
+	 * Write to memory the value of flush_status before uvc_status_start()
+	 * is called again,
+	 */
+	smp_mb();
+
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index df93db259312..6a9b72d6789e 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -560,6 +560,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	u8 *status;
+	bool flush_status;
 	struct input_dev *input;
 	char input_phys[64];
 

---
base-commit: 0ec5a38bf8499f403f81cb81a0e3a60887d1993c
change-id: 20221212-uvc-race-09276ea68bf8

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
