Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3461879E6
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgCQGzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:55:03 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:35470 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQGzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 02:55:02 -0400
Received: by mail-qv1-f73.google.com with SMTP id z4so19657303qvj.2
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 23:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Vz8Rl+tO3s2Fvzy9mMmth3PcVEenCGW3CyqKGLCsJ9M=;
        b=tdBd3JXMEOE0YT+L7rwOPZHaK8kRVwY4smj7X3+QwEyDXEwn7tlhTF4Ytp0NC86X6q
         fT+BVMQpi67m9Q7lWDaj5yz1NykcSCPNpGQVIgCGqBeH1Z3YwPU9zQxS2D9ZnXph+o+9
         hQBq1hYrgu7RWtKAszJvhlM964Knk9Pwoh/q+j+w4Kvxg0e3dKq1Mkb9+356AB/d/H7h
         iAD7OzZ0QrCyxEdaBvXRTCqKVt8QlI4DQXlT6N+Mz+wM845Q62Q3guDM61RAa9rg7bzG
         /LgCZAZbkmbfP7IiHAyTZtQ6S9+jLL1Ghvq0dxxWFL35GKxD7ldotwJLihuEfRF9jzU2
         dnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Vz8Rl+tO3s2Fvzy9mMmth3PcVEenCGW3CyqKGLCsJ9M=;
        b=td+8yWrQiKTWkWz8KksyMa+Ws2yeh/ES17VOpTdSlp3aCyXcaQ9AmQzmeFig3shY/F
         peUJM8J7S933KTbCjTOXNsmGp6EdK4FhiGVTTsSDbp+G0gJSr2ksrtT5ydhd1nrlZNti
         K1hpWtsYAcKCxftwr+EuxC4aEtYApT61tllKH3qgqQJziGJdPwOMxYfj0zXgXtDqRRGP
         AXvcRjzGeafBB93X8sp1rQCoORTdwiZpADkH0Z6MFL4mWmdoWIeYFzqgyqdTBbDpTej6
         faL0EI66bGM8XNLnnrzlFoBswwYYOIWVcWz8aT5z2D6NediwEUxxpqRc/hCd1CNV+X1i
         UkKg==
X-Gm-Message-State: ANhLgQ1Kw4HogzlXfE/4QpAxCmvO2v1t+44ZvTTTe0LcGwpV12hB0xHJ
        YPriECXG227yIlAAesh5YCOPSMFUjAG76TQ9hE2sYAA4+H6mSdCoi+VEvczYDtOelQ4BMJbdqIW
        J3uhNny/uZ92gnBhlUM5QkV6UUE3Nv3qylg/cd0s5lueODX1xhFqBubG+5hSM9VTu89OMLg==
X-Google-Smtp-Source: ADFU+vslXcTXZHxFbul+vKyVDDYbE109vB2qzmfCtTVliZ++Zd5h8tOc4jJH81ED+tXuc5j8cMzPwT/wJ2uvyfk=
X-Received: by 2002:ac8:5193:: with SMTP id c19mr3907270qtn.204.1584428101406;
 Mon, 16 Mar 2020 23:55:01 -0700 (PDT)
Date:   Mon, 16 Mar 2020 23:54:47 -0700
In-Reply-To: <20200317065452.236670-1-saravanak@google.com>
Message-Id: <20200317065452.236670-2-saravanak@google.com>
Mime-Version: 1.0
References: <20200317065452.236670-1-saravanak@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v1 1/6] driver core: Remove the link if there is no driver
 with AUTO flag
From:   Saravana Kannan <saravanak@google.com>
To:     stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, kernel-team@android.com,
        Yong Wu <yong.wu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

DL_FLAG_AUTOREMOVE_CONSUMER/SUPPLIER means "Remove the link
automatically on consumer/supplier driver unbind", that means we should
remove whole the device_link when there is no this driver no matter what
the ref_count of the link is.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 0fe6f7874d467456da6f6a221dd92499a3ab1780)
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 742bc60e9cca..b354fdd7ce75 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -546,7 +546,7 @@ static void __device_links_no_driver(struct device *dev)
 			continue;
 
 		if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER)
-			kref_put(&link->kref, __device_link_del);
+			__device_link_del(&link->kref);
 		else if (link->status != DL_STATE_SUPPLIER_UNBIND)
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
 	}
@@ -591,7 +591,7 @@ void device_links_driver_cleanup(struct device *dev)
 		 */
 		if (link->status == DL_STATE_SUPPLIER_UNBIND &&
 		    link->flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
-			kref_put(&link->kref, __device_link_del);
+			__device_link_del(&link->kref);
 
 		WRITE_ONCE(link->status, DL_STATE_DORMANT);
 	}
-- 
2.25.1.481.gfbce0eb801-goog

