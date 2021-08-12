Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3EF3EA949
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhHLRR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbhHLRRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:17:24 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4754C0613D9
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:16:58 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id n17so14689444lft.13
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 10:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xdyO31aY5oJHXthF/yLNWPoKfzIGPWGA/V6iR9KxXtc=;
        b=Exo/K0Y16AuohmBll0LChadNE8QI0TmR/PqlAwBwzKe+YOqY978WAmVjYn2WVKY2bp
         5q11NHKiUBcZ8owq4qGv6qoPYDVu9E3yJzKLU6M6yAn+2ag7eiyXH3JzjWDV1O6Y5xhx
         XUZj+3wz1f02gqNdcZy8yT2bPzPqoNd4nzCLw8gP9euYQRlWbSrfS/OlzBTdPW1i4rdy
         JUuzy/gyDfsBVodcigX627xzNMj8zFIww+LZajhsbsC5Xn0KLd6IKndm5Z72VPKp+J09
         3GIjzWmxlxOFcszzp0KyfS2AiQ7CrlC+grwEOMu1RIhccxRCfjfIuLk4Ulg8i6+xBdl5
         CnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xdyO31aY5oJHXthF/yLNWPoKfzIGPWGA/V6iR9KxXtc=;
        b=mbubLdVocURHNH5LyEmRkOHw7CatmGOGyxxdgcxLiA3/g2y71jIY4ua6DYWILKnMSS
         eOofBDFOf9LvQ4r5nDLUZygGn4e7gH//O/EgZ178emBNyNIMRcAAGFjvjJFTfunbJh+9
         cUkSiriozqKHEwPG2t4aEvCS/AaJpGZRzCMvvAa8WsOXwlCUIkqviWe7SmPJ9kAHm2Xb
         gNRNlU9neWc0v6gl8Z8UNXxXUiqUvzb/JDFBwUAv7pno/pZKVQapsuWHkKoAxv8z24LN
         CnziQ9cXRc2h/gL/Jckdzcub62uP4Fv1KjsahYHjS5WEUyuPLHGkHMvxD/4EilmQqFEc
         NPgw==
X-Gm-Message-State: AOAM530k0PPN5Wk9UU1tdOE+t2waMJgbYBTtvP8DLGrsPBX5yaDibZaK
        PeX74E5UGqXWFkjMYukP742nrg==
X-Google-Smtp-Source: ABdhPJzUtyryOs9cik/X6wyWAd7wH+MYBm2eLNHgQXrobGrzoKMVP85/OfyBq5+h6gaoNF+sVUiijw==
X-Received: by 2002:a19:6403:: with SMTP id y3mr3245781lfb.120.1628788617123;
        Thu, 12 Aug 2021 10:16:57 -0700 (PDT)
Received: from localhost ([31.134.121.151])
        by smtp.gmail.com with ESMTPSA id r3sm319731lfc.114.2021.08.12.10.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:16:56 -0700 (PDT)
From:   Sam Protsenko <semen.protsenko@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 5.4 2/7] usb: dwc3: gadget: Allow runtime suspend if UDC unbinded
Date:   Thu, 12 Aug 2021 20:16:47 +0300
Message-Id: <20210812171652.23803-3-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812171652.23803-1-semen.protsenko@linaro.org>
References: <20210812171652.23803-1-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 77adb8bdf4227257e26b7ff67272678e66a0b250 ]

The DWC3 runtime suspend routine checks for the USB connected parameter to
determine if the controller can enter into a low power state.  The
connected state is only set to false after receiving a disconnect event.
However, in the case of a device initiated disconnect (i.e. UDC unbind),
the controller is halted and a disconnect event is never generated.  Set
the connected flag to false if issuing a device initiated disconnect to
allow the controller to be suspended.

Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1609283136-22140-2-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 94c430dcce5d..bc655d637b86 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2017,6 +2017,17 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		}
 	}
 
+	/*
+	 * Check the return value for successful resume, or error.  For a
+	 * successful resume, the DWC3 runtime PM resume routine will handle
+	 * the run stop sequence, so avoid duplicate operations here.
+	 */
+	ret = pm_runtime_get_sync(dwc->dev);
+	if (!ret || ret < 0) {
+		pm_runtime_put(dwc->dev);
+		return 0;
+	}
+
 	/*
 	 * Synchronize any pending event handling before executing the controller
 	 * halt routine.
@@ -2055,10 +2066,12 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 			dwc->ev_buf->lpos = (dwc->ev_buf->lpos + count) %
 						dwc->ev_buf->length;
 		}
+		dwc->connected = false;
 	}
 
 	ret = dwc3_gadget_run_stop(dwc, is_on, false);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	pm_runtime_put(dwc->dev);
 
 	return ret;
 }
-- 
2.30.2

