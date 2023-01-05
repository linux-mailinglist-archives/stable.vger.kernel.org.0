Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A176165EEC6
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjAEObu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjAEObs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:31:48 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C632C559C3
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 06:31:46 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c17so52965836edj.13
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 06:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uxMEPkPChqTffTimg1+lT4mVoFm2SlkoFtahp543sh0=;
        b=Nl2kb6flwGDa/iE2cYHmUTREyxoI03PSIKAOACnDv0zDyr/r6i2HHU6mdZWOm4nrfv
         x6XzkAQ3xmcK6lojVZPPTVhtyddOUcGOcael8rEW5NGma18D0QKsKNba1rUnRLGkpQBh
         /UA7dBAflrPLSKJmwMhGsYUH4kHx2QoNV5n6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uxMEPkPChqTffTimg1+lT4mVoFm2SlkoFtahp543sh0=;
        b=XXdXTYyUk0+pK3OFR1AOjmB09Ip9H7x8643aHnF7ZH8uvcPH7HAK0vCD6zEMRf+vuS
         IJUoI6jEpPdly7V3/UFMkj0yrsIEC9qTEftrln7pUTGOTE4vgCUogC+3Y2JJsJhT9zrJ
         djMjAJf8IjtTKYyOkM+UjxrMZ8YFFNtpg3djprQXpGUBrQkNeMB+1tQSQq+GTRc7xpQn
         v5HhF14X1kW3DTiVmgPs2YuATwyQOBAUu7TfgdTTP/lnnNk1Hu3uhmmYlWGqsSNF+98b
         wEjohPa/a+P8egRLlAGQ9RfgiE8URFsws1lXIGebA4lJF/iCMVBlPrFk+sZaA3AJOg50
         Ndjg==
X-Gm-Message-State: AFqh2kpVAd/SsNDH30NAeWsBM9cuBYjKXObB99C7O54PQp1/AtEXs/M6
        OoN57RDEZJmk0FO/cTNmahivlA==
X-Google-Smtp-Source: AMrXdXvThc/7ejFs6s8dszQ2WW4cbnwa87HriIjX74fGe9V9LDDd5Jl1o5hHNV2FTHwgYU31lzJEOQ==
X-Received: by 2002:aa7:d04e:0:b0:45c:835b:ac4d with SMTP id n14-20020aa7d04e000000b0045c835bac4dmr44636174edo.8.1672929105339;
        Thu, 05 Jan 2023 06:31:45 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:848f:5924:dffa:3b5c])
        by smtp.gmail.com with ESMTPSA id c4-20020aa7c984000000b004873927780bsm10818084edt.20.2023.01.05.06.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:31:44 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 05 Jan 2023 15:31:29 +0100
Subject: [PATCH v7] media: uvcvideo: Fix race condition with usb_kill_urb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221212-uvc-race-v7-0-e2517c66a55a@chromium.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hillf Danton <hdanton@sina.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Max Staudt <mstaudt@google.com>
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Yunke Cao <yunkec@chromium.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=6479; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=cW2kwv2siZICftxj75pqCs1K4XmG0NtU3yyQXAzdBG4=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjtt9JhJKajr03HfmLDxie/eqxiOch8paSA4cqVoct
 S4TdcW+JAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY7bfSQAKCRDRN9E+zzrEiFyeD/
 92GkSmfrDtKn8ZTQGY6JNCoQA7Yh7pbAvIn/+G0H0e2+A8d9Fcc4BrYob+WxcFsfrhapFdJgZx2Pbn
 3Tu8XCG2B6Pm5yWP4Lok3Dh+DrHEdS3+/Hrwwo8zkP9ZCsHF+klVHVZp+yKi9LLUEDW6yUAoPpCf+M
 p9CNSIIV9Xf+T76bwb8k9h5E8aoy+IYvQWl6yCIboANF1Cg7pcycXerkP5qiLz5Jb9BSmtbEXeqlIC
 nqXRPuUMDV4Er6lnzNPbyIttEHqqyrr+ml3UvWIpfmCIxRM9eI7B/gzudWW4LoqOeZ4qp7cXYPpGua
 GjkZBXWSu5OF6RO1aUdvVJsOupJLFmWXBVZp2dvfx4V1ye1v5QFQMD8anl3cyeWgVtMWrgG4WZqYtq
 LLbluvTvdMW5ZqSWiwWdk6iE5YYHgOWVT7SbxSzJLOHeRb9qi3HuZETQyluzjYRAHDA0vWrvvzxA6N
 xOHW2pFwBkTphznOd7+y2Id9SIwzdgwsgGnCkCSPUGJ2M90OpnpjPwITti6Ywm5g6gwSHZ2+L9aQtW
 M15xeaKDfzClDp2y0L8tE9/raf3H2NC9M8e510cVVwAHj2IY97JM9n6Ri40ZYO+UdImbqiFjHhHqAO
 qdViYbLxaESv4umeSyYe5u9zsbzedumqjw9uyCzJRcl0P7paYBULLvnBxuNw==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

To: Hillf Danton <hdanton@sina.com>
To: Yunke Cao <yunkec@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Max Staudt <mstaudt@google.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes in v7:
- Use smp_store_release. (Thanks Hilf!)
- Rebase on top of uvc/next.
- Link to v6: https://lore.kernel.org/r/20221212-uvc-race-v6-0-2a662f8de011@chromium.org

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
 drivers/media/usb/uvc/uvc_ctrl.c   |  5 +++++
 drivers/media/usb/uvc/uvc_status.c | 33 +++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index e07b56bbf853..30c417768376 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -1509,6 +1510,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 602830a8023e..21e13b8441da 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -311,5 +312,37 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/*
+	 * Prevent the asynchronous control handler from requeing the URB. The
+	 * barrier is needed so the flush_status change is visible to other
+	 * CPUs running the asynchronous handler before usb_kill_urb() is
+	 * called below.
+	 */
+	smp_store_release(&dev->flush_status, true);
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
+	 * is called. The barrier is needed to make sure that it is written to
+	 * memory before uvc_status_start() is called again.
+	 */
+	smp_store_release(&dev->flush_status, false);
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index ae0066eceffd..b2b277cccbdb 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -578,6 +578,7 @@ struct uvc_device {
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	struct uvc_status *status;
+	bool flush_status;
 
 	struct input_dev *input;
 	char input_phys[64];

---
base-commit: fb1316b0ff3fc3cd98637040ee17ab7be753aac7
change-id: 20221212-uvc-race-09276ea68bf8

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
