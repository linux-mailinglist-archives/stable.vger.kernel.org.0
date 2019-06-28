Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74DFE5A36E
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF1SYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:24:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42946 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfF1SYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:24:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so3390552pff.9
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 11:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=80ekKnnJbJ+N9S8CSdtwlr9DiGvzY1b4sXIFJmFharo=;
        b=N7n5rsXUCKOo6iC/j6Yoz9nSlgDmhyVVXfwTfbqvI75MhNqSHBZsu4UTtnGk8jwnRF
         JqwdgJqAPKCBXPBDgBNzH9lPdRsDPtse3H4Vy+BCQxCwiDK6eWz/q4Z+H7DWjEmhmfPH
         7NMrKie2+MIA0cv9h52OEILExdLi9Hcd4CTPftfm2fuLKQXzIjSGTcRhFX//WCnMQguZ
         dEZvZpfGFB0AvGkSJHD24Fc9fN/OYEuugW6/Zde80HoCUdKux8R65Q7z2wW4ba87gjrr
         mOP+oLCf0Qr+r1i0D6AtaTcua9wlmRg2n820LMTDC32lDtniMVCg35R0eLhIUN/hDczp
         Muow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=80ekKnnJbJ+N9S8CSdtwlr9DiGvzY1b4sXIFJmFharo=;
        b=huoY72kk5XtvgsKIkfYsWyrJscq2hmCwyX3bmj5WCE/frlZhE5KmSYuiqdU6K30NbB
         XfyoXfJFW6VXcRwpRC6xxjw0zwHE1mO4DhziB/QlroB1wJFwDeWeKhrLxO9zxt7+J+/u
         rRNW8OxwqjmghIYwHkgG+lSYmGzQYo42BZ3zqxzhT75xaGiOsrfo5W0iOwvHzaWbspwJ
         wwcjqH6QmrOvOA5krqUh5l2ReXAhgi4tpuYlZayFrvQOH0TPcZ4ndnIF6/3flnvpZ6Hx
         WoszaNoPzGGruMzkMvHXzXWgygi5mfUKnf1IC90rBcy+CetoKrZYhfiv3+VRCZBCXX8A
         xDLw==
X-Gm-Message-State: APjAAAV7fb9hoaIEGM8H6mWVIeFWocridD37SCs9omwtKFTstn7OVJJi
        J4OLk5HEXyPngeEzZnep6HKg4Y/WJA4=
X-Google-Smtp-Source: APXvYqyYnBAyWCgFARuxspznmYO7UnkE0AX8irdmIt+l6LSBhyP2TvzeVO9riPN40MErj5bcpzk/jQ==
X-Received: by 2002:a63:db07:: with SMTP id e7mr6227730pgg.110.1561746259294;
        Fri, 28 Jun 2019 11:24:19 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id s15sm2916223pfd.183.2019.06.28.11.24.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:24:17 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH 4.19.y v2 1/9] Revert "usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup"
Date:   Fri, 28 Jun 2019 18:24:05 +0000
Message-Id: <20190628182413.33225-2-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628182413.33225-1-john.stultz@linaro.org>
References: <20190628182413.33225-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 25ad17d692ad54c3c33b2a31e5ce2a82e38de14e,
as we will be cherry-picking a number of changes from upstream
that allows us to later cherry-pick the same fix from upstream
rather than using this modified backported version.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 65ba1038b111..eaa78e6c972c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -177,8 +177,6 @@ static void dwc3_gadget_del_and_unmap_request(struct dwc3_ep *dep,
 	req->started = false;
 	list_del(&req->list);
 	req->remaining = 0;
-	req->unaligned = false;
-	req->zero = false;
 
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;
-- 
2.17.1

