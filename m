Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A545CB98
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfGBIGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfGBIGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598A920659;
        Tue,  2 Jul 2019 08:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054766;
        bh=CB5n+a0I0IeR56VJdQ4Is5/pAx6Z9g+uxpADhmcURPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m79YMNG+4JFt41RzygCFD2lpaep8Y2pzgaRC+DhKaB/SsRNqk/odM6SYmeHhClON3
         PCI96k17V5irwXd5OLZg0HGtqNtNtJ5zkaxoR6l6fNd0yrpXdO71BuW/FcTR6ctmnG
         Q3aD9jAcHjL0oEnnfYCqX72hHq7OsnG5U6GYfkRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/72] usb: dwc3: gadget: introduce cancelled_list
Date:   Tue,  2 Jul 2019 10:01:29 +0200
Message-Id: <20190702080126.132412439@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.20.1



