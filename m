Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6257858C0E
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 22:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfF0Uwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 16:52:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44594 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfF0Uwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 16:52:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so1800862pfe.11
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 13:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZrL274DhNKyTQBw9OhusDzJRVLn3r/FwIe97KUSVcog=;
        b=LijsNOiRu7AOnbIFYl8i2/9YtZD/HBFXNXyokFi7ArT8pjo4rUhbK7ZABtYNbou5t7
         vZwPWaBA/26JvKn/KJqALkNkLyNPIURIWlmMOajizfJxyMyqtZpBg3Cs3SP/a4s4W471
         NH/JKDXu9Xjg/AYuN4bjY+33UeTX4fwXjAYuUYb+0ArMMJzWdgcrbVids31C6xdG3cRW
         GjsQzPsW5g2ZWRDPTaCLM/U2OiBC4uJ17u9EV3uGyVURg1OOumzJy0Y4/9APc5AUQoYk
         3a6tr+pEeHEoYwQEe8zvX4DiIEZm6lpJey83CFiQxv7JdnN2qUotZjw9Xd1vUfIKXgcj
         A3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZrL274DhNKyTQBw9OhusDzJRVLn3r/FwIe97KUSVcog=;
        b=GVOcPfnBSb/urPMGd13nALDzXS85re7E5Soq4YEw07h5ik5wMxqMPSy24XOVCrzN6r
         xo5LXCM5+R8fFcl9o2z3wFTQIzSRhxxBkW9XQqm0QJGIBW11yFjGY0TKlM7i9CAbTiSm
         0Or6HhO1NEUet+5dmPI0xMOileDdfXYRTIVscg9//REbdtF15VkLkA6W/vySG0P1up4y
         5aFjtNI6+jrjTZ6qIRhh04O8bGr51BTZeELcHWbzCWBPc3pq7UimVFbOfiFEGzsGZSP0
         VaM6yD+ZUWlsikzENr5mU/1gzY+glyNagzEeU5mOPGYUbovZhr4xOeFHTN3OyExmqEHF
         dqXw==
X-Gm-Message-State: APjAAAVnisieQWTIzdV/nXKCv0fOcpXtVGJX2q2bPceHiXVwXrT8Afel
        GCQ056CY0FTKLEpy1ipPPy5cgwdzeYE=
X-Google-Smtp-Source: APXvYqwo0ph4DAMPKAKH/MsnyPj2uoZWLuEKCKC099RmQ8ouNVtkjqZJdDaOlT9eegAIdii+wQO9Tg==
X-Received: by 2002:a17:90a:8d86:: with SMTP id d6mr8058912pjo.127.1561668773759;
        Thu, 27 Jun 2019 13:52:53 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id 2sm3674083pff.174.2019.06.27.13.52.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 13:52:52 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4.19.y 6/9] usb: dwc3: gadget: move requests to cancelled_list
Date:   Thu, 27 Jun 2019 20:52:37 +0000
Message-Id: <20190627205240.38366-7-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
References: <20190627205240.38366-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felipe Balbi <felipe.balbi@linux.intel.com>

commit d4f1afe5e896c18ae01099a85dab5e1a198bd2a8 upstream

Whenever we have a request in flight, we can move it to the cancelled
list and later simply iterate over that list and skip over any TRBs we
find.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
(cherry picked from commit d4f1afe5e896c18ae01099a85dab5e1a198bd2a8)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 34331a9fb584..25cdce359736 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1366,6 +1366,17 @@ static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *r
 	}
 }
 
+static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
+{
+	struct dwc3_request		*req;
+	struct dwc3_request		*tmp;
+
+	list_for_each_entry_safe(req, tmp, &dep->cancelled_list, list) {
+		dwc3_gadget_ep_skip_trbs(dep, req);
+		dwc3_gadget_giveback(dep, req, -ECONNRESET);
+	}
+}
+
 static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		struct usb_request *request)
 {
@@ -1402,8 +1413,9 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 			if (!r->trb)
 				goto out0;
 
-			dwc3_gadget_ep_skip_trbs(dep, r);
-			goto out1;
+			dwc3_gadget_move_cancelled_request(req);
+			dwc3_gadget_ep_cleanup_cancelled_requests(dep);
+			goto out0;
 		}
 		dev_err(dwc->dev, "request %pK was not queued to %s\n",
 				request, ep->name);
@@ -1411,7 +1423,6 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 		goto out0;
 	}
 
-out1:
 	dwc3_gadget_giveback(dep, req, -ECONNRESET);
 
 out0:
-- 
2.17.1

