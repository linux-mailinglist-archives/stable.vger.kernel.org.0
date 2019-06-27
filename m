Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8440A58C14
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfF0UxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:53:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45496 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfF0UxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:53:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id z19so1535986pgl.12
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PDI+SV9GVbs38aQev8L4wXqHdjl41NulymWKKVfYEMs=;
        b=FT+BOXS8krhFYzP6qgkGdTRIuN8UEsdd7/J8Rk/TUCvNz5vD+gALlNCjhBRbIyg2+e
         MhGEv+r6MSWMg0hPYeg+IO7ul1XPK65iNNIVI6Z0n3TbWoWyTiOzVSbZ1TrHf3P5bsll
         wflv/q/ksLyXrQJQzt13c5gcCn8ChgNlwa8D+06Mp8/blyCxT/DNAUTeVhtYIwNTTRAH
         4A1YRmiJzIY8sAIaajfuF2qEu/ZXMnUvTcYbEzmJ6DRI23NNxVHK3EGJZXFDvOONHjVy
         b/x/iCuPGw6JGjnvJCYoxYs7SzL/j19MXh3Z+y+kfPrn44MA+V+WR3aP1HHbvclQs3GO
         cEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PDI+SV9GVbs38aQev8L4wXqHdjl41NulymWKKVfYEMs=;
        b=pi7jGkR8hXsMbMo6o4l0tsKFzugZSHVcHEDIBUlu1cm+XQX/pY7R1FqGoB6R2sRN+s
         H3XEyjNNmzMJ2BB8bpSb34ZLBwhAjUXI8R1W4lM5yFSTk7gnjhuY9AfbSskJ8oZfyLq/
         k4itOEj9U350ulUyiyzBa++gV5NJSrwBo861KPXKuXrZ6bLUDmRHPJGiCOde7ggLacXZ
         b0cZ1+jwSMjfdXJ11AaKiwfZoUVNPgWlKDZXmmGSg59WoXytCAB5RmNukn0MtGmUhHSR
         pUQu8XCXcF6+DFflSulMSXwzdstvcIqJBQWtZMW6BMSqUKQx2jdprUMVglJ+DmHyuk+X
         vlPA==
X-Gm-Message-State: APjAAAVRsL8fDtAohoXUNmG2EEnDOE26zJTtqmV/jcHXkmiqS2qCGJhY
        d1EP/pXGJb9Ray64p8zJLeWsZeA0yYE=
X-Google-Smtp-Source: APXvYqyBb+wX2HfJ0wt7W/TgcNxknQdoGdW16YqdoS56BW7Ng+PgtitplGMtO7YyOovSzLxYZ3UKug==
X-Received: by 2002:a65:500d:: with SMTP id f13mr5539367pgo.151.1561668779150;
        Thu, 27 Jun 2019 13:52:59 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:58 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Jack Pham <jackp@codeaurora.org>, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 9/9] usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup
Date:   Thu, 27 Jun 2019 20:52:40 +0000
Message-Id: <20190627205240.38366-10-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit bd6742249b9ca918565e4e3abaa06665e587f4b5 upstream

OUT endpoint requests may somtimes have this flag set when
preparing to be submitted to HW indicating that there is an
additional TRB chained to the request for alignment purposes.
If that request is removed before the controller can execute the
transfer (e.g. ep_dequeue/ep_disable), the request will not go
through the dwc3_gadget_ep_cleanup_completed_request() handler
and will not have its needs_extra_trb flag cleared when
dwc3_gadget_giveback() is called.  This same request could be
later requeued for a new transfer that does not require an
extra TRB and if it is successfully completed, the cleanup
and TRB reclamation will incorrectly process the additional TRB
which belongs to the next request, and incorrectly advances the
TRB dequeue pointer, thereby messing up calculation of the next
requeust's actual/remaining count when it completes.

The right thing to do here is to ensure that the flag is cleared
before it is given back to the function driver.  A good place
to do that is in dwc3_gadget_del_and_unmap_request().

Fixes: c6267a51639b ("usb: dwc3: gadget: align transfers to wMaxPacketSize")
Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit bd6742249b9ca918565e4e3abaa06665e587f4b5)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 843586f20572..e7122b5199d2 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -177,6 +177,7 @@ static void dwc3_gadget_del_and_unmap_request(struct dwc3_ep *dep,
 	req->started = false;
 	list_del(&req->list);
 	req->remaining = 0;
+	req->needs_extra_trb = false;
 
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;
-- 
2.17.1

