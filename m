Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF6E58C0B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF0Uwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:54 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46884 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF0Uwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:53 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so1906356pls.13
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FFCtQU5sSYcakyL0pYyK6CZbXF6VG4/IPn3EqOoScBQ=;
        b=i6g7tyjsi0VqwFXI1RCnbQJnRRMBe1r2ij/wCB60zhC2J1rHRwUKJehchm8A5BPQS9
         gFrbbdav83VFym+Vm79VqtmTYMfgUYrtNt6vB4uB3cVqx7Q0xtDmg/sXrTofJQ5CwZHu
         Tph57dgwsQyz83Y5PIifEw+2r7iZOwGf54sGX4fhnXEWnWWGMVegbVsDtkemjZnPlvmN
         3CGXg/XC3Atx+8BWCEFxJwN0TS9gxqMlzrelHEcK++Jw4RoHLINYHJADQ6+0cn/hkMTV
         eHFWB1wTFNeTW9zP5jLqrtjVG5dx8EhPsV9gYhFzzSJC6sicmxZPzD952Ih/9+PPYzkZ
         IIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FFCtQU5sSYcakyL0pYyK6CZbXF6VG4/IPn3EqOoScBQ=;
        b=cqh5K92+NedBXnmuBf8IkkS+VGeCUH1GWyJ24H0/aqNnHDhNjz17G8rBsPYLK9A8CY
         3ZksFN6WChY6LZZUDU5dcD9gcwBBCf/2EvXZwYvSIl2Juw2zJTNod6KkS+MgNUOIXlTy
         SNTNKZqoXyLKgOiZuRWKQxSjd2Mx0QpChRXHiBqPgty05CP2BMPYQltdh9iZgnhXC5uQ
         IhCjiajkHkT+hZWzJ+zjxdH/kZDQnXlFov3qOTevNJLfofveVWJcfae6ai/SxjiSaboH
         AA82Eu6O38RSyUgQZqMhaAZ88EWUygpNaLCYZMOyQQREnx6FKVILmPVDhCJtQ0uXXcrK
         0Pbw==
X-Gm-Message-State: APjAAAUcVqMuxlS725/4unaG9u8kT01bqbG4iApJoiZs0FA6enAVbYYA
        zYX9sOBqEtsxeVtArW2T2rI9JoI4W+U=
X-Google-Smtp-Source: APXvYqwABklyTTxO1LkkcxWaehjJJvJc92mMugHgTs1JfmaCljr1SVdn3N3uUvR8aUW8F1cG7ujZIQ==
X-Received: by 2002:a17:902:f81:: with SMTP id 1mr6893773plz.191.1561668772388;
        Thu, 27 Jun 2019 13:52:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:51 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 5/9] usb: dwc3: gadget: introduce cancelled_list
Date:   Thu, 27 Jun 2019 20:52:36 +0000
Message-Id: <20190627205240.38366-6-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
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
index f0c3b08ff7c6..34331a9fb584 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2146,6 +2146,7 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
 
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

