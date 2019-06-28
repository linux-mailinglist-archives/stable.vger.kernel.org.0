Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744105A378
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfF1SY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37807 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfF1SY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id g15so1049634pgi.4
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DDZGKZ3w7wUwrEm8FX1ASPwXOimJmyPEnuezYoXx+I8=;
        b=CFr4YuFAJ4CxD6EpGmjrwbV8ZIDMplHe16uLlYTmXLMT/n8sVa1kkkDZspxOIo7N4Y
         iwHYu38lElMkN+RfwzTsUxMoed7bGFFRCOZGWXlCB22crZeKZ+8FrV9hwzyiI9vZTLlI
         rzzeHEMdgj3VQckfWLa+a88HPnC5E1Suwv7H0SKFUfLxw7hyUO97PHn2tyCcGUrK8Q0u
         d6erI+z85f3CcHZQyLYs6YsF459KLnDFEP7hTdtKgvJY9j1tsTd7H2VXnDkM3OAd9Vag
         ht6sy4mXJpGFRKIZ3tT9/SL+r9gEmXwS7lu8bPw2ue7+O6uSPxX9PGa5ttRXn6kQbX4e
         qSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DDZGKZ3w7wUwrEm8FX1ASPwXOimJmyPEnuezYoXx+I8=;
        b=CZ6cu9KHO++h59FT/W2TAylBWrmvl3Vl0nmA2cXCFqfLo7/UjEGrbT/12y8h6r8K3e
         SckBK1t4UnkaUggAD7EcHEf7PKA8Q73S44Gz0Ws9nYVNWi3CPHsSX91LLubWu/6lF1wp
         Z1/7Hec6FijsMIl4lMrkFsVXpGpitzUMC9fw0o18e+EjTGHSmqS92Ij+c8ri9myuBQQ2
         B6uD7Yejc0LbNb+/LrBBTw+/4KqWX5X7xuw+H+CZGBJyrFepw9mco49/E2RgXtl3jdbj
         50nMVu2npWy1PPvPsv5VyhO9kGre4ldvuUI4bXeRYX1TMhIeM1z3INdLB4V9/lidilKO
         qOdg==
X-Gm-Message-State: APjAAAVLsf1JduhGFznxV2z951QiAZUtBFIm6xWngbKStKLV7nBbA4LP
        8wu4A4OHtoXJgIyg1iS/QMujuhQOGio=
X-Google-Smtp-Source: APXvYqx3g7h5vvxkXrT1Ioc3tfWK+hwMhoc+6Gew5Hk0v0/fv3t0WaflZUIIz+aQTaGKOOsB4v7dRQ==
X-Received: by 2002:a17:90a:a489:: with SMTP id z9mr4530868pjp.24.1561746267725;
        Fri, 28 Jun 2019 11:24:27 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:26 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y v2 6/9] usb: dwc3: gadget: introduce cancelled_list
Date:   Fri, 28 Jun 2019 18:24:10 +0000
Message-Id: <20190628182413.33225-7-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit d5443bbf5fc8f8389cce146b1fc2987cdd229d12 upstream

This list will host cancelled requests who still have TRBs being
processed.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit d5443bbf5fc8f8389cce146b1fc2987cdd229d12)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/core.h   |  2 ++
 drivers/usb/dwc3/gadget.c |  1 +
 drivers/usb/dwc3/gadget.h | 15 +++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 0de78cb29f2c..24f0b108b7f6 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -636,6 +636,7 @@ struct dwc3_event_buffer {
 /**
  * struct dwc3_ep - device side endpoint representation
  * @endpoint: usb endpoint
+ * @cancelled_list: list of cancelled requests for this endpoint
  * @pending_list: list of pending requests for this endpoint
  * @started_list: list of started requests on this endpoint
  * @wait_end_transfer: wait_queue_head_t for waiting on End Transfer complete
@@ -659,6 +660,7 @@ struct dwc3_event_buffer {
  */
 struct dwc3_ep {
 	struct usb_ep		endpoint;
+	struct list_head	cancelled_list;
 	struct list_head	pending_list;
 	struct list_head	started_list;
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 46aa20b376cd..c2169bc626c8 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2144,6 +2144,7 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
 
 	INIT_LIST_HEAD(&dep->pending_list);
 	INIT_LIST_HEAD(&dep->started_list);
+	INIT_LIST_HEAD(&dep->cancelled_list);
 
 	return 0;
 }
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 2aacd1afd9ff..023a473648eb 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -79,6 +79,21 @@ static inline void dwc3_gadget_move_started_request(struct dwc3_request *req)
 	list_move_tail(&req->list, &dep->started_list);
 }
 
+/**
+ * dwc3_gadget_move_cancelled_request - move @req to the cancelled_list
+ * @req: the request to be moved
+ *
+ * Caller should take care of locking. This function will move @req from its
+ * current list to the endpoint's cancelled_list.
+ */
+static inline void dwc3_gadget_move_cancelled_request(struct dwc3_request *req)
+{
+	struct dwc3_ep		*dep = req->dep;
+
+	req->started = false;
+	list_move_tail(&req->list, &dep->cancelled_list);
+}
+
 void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 		int status);
 
-- 
2.17.1

