Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D575A65B389
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbjABOsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbjABOsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:48:12 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284F664C3
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 06:48:11 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ud5so67010001ejc.4
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 06:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+okEzV2zBdHwNj7DEszLP2mtdrLQi0h+BSkRAR7jQxw=;
        b=jr6GEGlL94jU9hne/o9BdhUQYxbLmYpuFwXfDalZ88hYQ7Rx+t/AUWgckvpQ7Flugg
         gnVca1In/VusgpJJEQjHD1UjEhz3aqK59p6fJ5QoGcp6+7lB6N/TAjX46tB53l8/kK1L
         Lm3c85y4+eVK9CmEhV1fnZB9bqAoLefUNPbts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+okEzV2zBdHwNj7DEszLP2mtdrLQi0h+BSkRAR7jQxw=;
        b=leB/djRgHyzCnQmrfxlgTvAdx+z9qXde6NR6pAEn7XlpHtymEW//ySINu4X8T7NvL5
         OmOoKDfZZoynUk1424oV/bXJpGY+jhVhm9Hbix6z64uPjpy5F/QPtw3P6lQqMRU3R7Fh
         j8/Aqfn3G8eVhgA7BBVXRfdtVe8zzHzI0ekdG+6q217HPft0YYf+d/Nkn7tjy9FL+rGH
         3W9qTNcO3/Rj/1z0YHrJYEgYcBVs4qNTXIu6IlHESkdghfK0aby6u+exp1l/O6DJOQZI
         BZppuHkKrx+B5GIai672Jdd8GzM1E+nlYHXJrHpQE6zs/ItxwskES7h9lUG4y8xClklr
         NCZg==
X-Gm-Message-State: AFqh2kqWocwQw9FY9mLJBU+9ylwOW9N9RXa+m0sh0uTz0fIV/EQaBRsO
        RE4fnfLpgUPqMNgOPwuAPH5i6g==
X-Google-Smtp-Source: AMrXdXvU6QFKesPnUhP8MEnmUGjftcZTE+4Kg1zLMf09kow3Ss7mrQ8yIgUiqNqzbKfpCHK2l9KQGw==
X-Received: by 2002:a17:907:8312:b0:7fc:3fef:ab86 with SMTP id mq18-20020a170907831200b007fc3fefab86mr29857890ejc.71.1672670889731;
        Mon, 02 Jan 2023 06:48:09 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:6ef6:ea10:76ec:977f])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090632c300b00781dbdb292asm13064795ejk.155.2023.01.02.06.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 06:48:09 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 02 Jan 2023 15:48:01 +0100
Subject: [PATCH v6] media: uvcvideo: Fix race condition with usb_kill_urb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v6-0-2a662f8de011@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Staudt <mstaudt@google.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Yunke Cao <yunkec@chromium.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        Ricardo Ribalda <ribalda@chromium.org>
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=5952; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=OlBUT0d0UDR2+oDUQbmPwKuQ+fnKJ1FL06u1EsfTbt8=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjsu6ick7OJ1WRu4rYZaD1P3Xj9qmSGYqV/7icskpq
 t+TImPKJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY7LuogAKCRDRN9E+zzrEiEMiD/
 93msrnCV2Ux9hqvFn3RKES7xI+hZLJCiuw1Y9XBxrP4p6CzOjicG8ZEL5rLwB6lPfh3Ipe+T2bWESv
 OHdn12VvQ3ydnaibggh1ZBJh9FyHRyrQFoWOyy0TufwQE8d5nmwLgCHOew0dnTBa+zszwAwZcWjYOK
 tFgrw8J8mqRalRUV4JZQDdLSvjn/MVjv5hZ00iWQK8pXhrmgMkrkgScrNkBC9tngDLC9JZBeFkuyzd
 dB/ZSo0ItexKTspXMvJ25TPAkCplKvCCjc1LzMQBJYpNKKBQQ4R76+sXhjaf+D7JvqGVBsBkBV8Q9Y
 KnxKp31V8twHhhbQQOvcJiLWXp24gZOsP1CK9X8xBFTfEh1Zx4nUcIKE3eeP0ohA87d3nnVjvfc2X6
 ncJWKHZ3yq1MN2fHDIzN4L5b2EcQmMJsoO2gy3Ach/d/ItODlt0rI8up5rWuG4N2lwyBUWAib4uQZq
 eVfc96dpe0hbv2qlPS2WIw6OaERLeP831Z01NwId8S/Wj5fP7p7HgVjam1HswZutlv0q7vjTm5y7ri
 4fceDwrlplf3gexCa7KXeie4Xqs2w95uGf+TBU91bUglNXq2MdrSbnNYyjtb7TwcU67O8vxVW0OM2Q
 EN0no2ac3JcmqZpwUbTE9kmLk0aNXeB5I9MAks4Z80rSShxE1AgN2bJcKhXw==
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
Changes in v6:
- Improve comments. (Thanks Laurent).
- Use true/false instead of 1/0 (Thanks Laurent).
- Link to v5: https://lore.kernel.org/r/20221212-uvc-race-v5-0-3db3933d1608@chromium.org

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
 drivers/media/usb/uvc/uvc_status.c | 40 ++++++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 44 insertions(+)

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
index 7518ffce22ed..e457889345a3 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -309,5 +310,44 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/* Prevent the asynchronous control handler from requeing the URB */
+	dev->flush_status = true;
+
+	/*
+	 * The barrier is needed so the flush_status change is visible to other
+	 * CPUs running the asynchronous handler before usb_kill_urb() is
+	 * called below.
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
+	 * The URB completion handler may have queued asynchronous work. This
+	 * won't resubmit the URB as flush_status is set, but it needs to be
+	 * cancelled before returning or it could then race with a future
+	 * uvc_status_start() call.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/*
+	 * From this point, there are no events on the queue and the status URB
+	 * is dead, this is, no events will be queued until uvc_status_start()
+	 * is called.
+	 */
+	dev->flush_status = false;
+
+	/*
+	 * Write to memory the value of flush_status before uvc_status_start()
+	 * is called again.
+	 */
+	smp_mb();
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
