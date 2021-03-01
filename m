Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF0327D9B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhCALvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhCALvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:51:36 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8ADC0617AB;
        Mon,  1 Mar 2021 03:50:25 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id h4so18849376ljl.0;
        Mon, 01 Mar 2021 03:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a3fR6Ve9ApfA3U9S3BpD3B/5uX3W9BFd2HZqD0/PdZ8=;
        b=q66A64NZPNqkvC4oe3MmZyrXQypU9F6L0QalEafsT9IWPw19JIBFuqXDETzroRjd1K
         aTBI+nGokloLb9t2fOcmIHr0b3W3fAU9Jox9Xb5NyJqevHm1GuSyyhDk58dI7i9+T+oc
         11PY092Bc8jd4b/kRAoSCqdiHMACpA2VS9oA5Bo84+rkK/a+uab8SXznuNAs1RGiHanj
         VRjQ8UW4wRNOacj6TDZtQDtZ4Z1xZb+25zwlQvkJxnpHXuqg7fcuKP064HGEyublsn5q
         lUV4C1et6KNBO2LEsbsc7DTYPGtKWDKRXIPkLUOUzMmWa7rabhDbsY9dfQGA1Irc0ZJf
         KvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a3fR6Ve9ApfA3U9S3BpD3B/5uX3W9BFd2HZqD0/PdZ8=;
        b=CckZf1poLubYIl+dM7gKYT3KcBwpYc6eBWCjHJE9hETqdz1HRhVg9Htv6aZ6WMmyEr
         eCusnviBZIxzhJrMYwtnSvWNaxt+MkBXDSQLt6SdQsOrH0vsRoUXoB3W8d02NEBrVlJe
         RPcLsUlHucJB6q95W2h6Wf1hHrW5yGBDPx2E/p/+6rE7UlxRGkQHMiUV+taNI6XR9cRz
         3fPrA0lRr8z3YEiSH6RdFQPXDQKoZBRAFizXNs9Cu51PEFRiSFznRAmCj9z6NkzTxQjo
         JoZrHryPOnI7lI/jIxG8cH4Qt/Pkb/PO+YLJLNFl1Nx0LqRo5bh03Yzb4jAfj4Yhqs5y
         /Nhw==
X-Gm-Message-State: AOAM531zXtc7zooK61N2o4sxJQJcrjMzhfgQSklAVGsnzhV9k4UgTeg8
        6FUWpDywZ1V3B/CKGb7gqkI=
X-Google-Smtp-Source: ABdhPJwnSYhbab864Cs0ltPO/LykuBv5ECJo3g7ntR84sDrjyLYIJtC1UNNaaUGeIvpxBWwmIghnVQ==
X-Received: by 2002:a2e:7d03:: with SMTP id y3mr7332648ljc.0.1614599423944;
        Mon, 01 Mar 2021 03:50:23 -0800 (PST)
Received: from localhost (crossness-hoof.volia.net. [93.72.107.198])
        by smtp.gmail.com with ESMTPSA id y26sm2281587lfh.279.2021.03.01.03.50.21
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 01 Mar 2021 03:50:22 -0800 (PST)
From:   Ruslan Bilovol <ruslan.bilovol@gmail.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/5] usb: gadget: f_uac1: stop playback on function disable
Date:   Mon,  1 Mar 2021 13:49:32 +0200
Message-Id: <1614599375-8803-3-git-send-email-ruslan.bilovol@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1614599375-8803-1-git-send-email-ruslan.bilovol@gmail.com>
References: <1614599375-8803-1-git-send-email-ruslan.bilovol@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is missing playback stop/cleanup in case of
gadget's ->disable callback that happens on
events like USB host resetting or gadget disconnection

Fixes: 0591bc236015 ("usb: gadget: add f_uac1 variant based on a new u_audio api")

Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
---
 drivers/usb/gadget/function/f_uac1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 00d3469..560382e 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -499,6 +499,7 @@ static void f_audio_disable(struct usb_function *f)
 	uac1->as_out_alt = 0;
 	uac1->as_in_alt = 0;
 
+	u_audio_stop_playback(&uac1->g_audio);
 	u_audio_stop_capture(&uac1->g_audio);
 }
 
-- 
1.9.1

