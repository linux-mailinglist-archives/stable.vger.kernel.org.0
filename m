Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FF2381610
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 07:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhEOF1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 01:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhEOF1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 01:27:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8ECC06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 22:26:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q6-20020a25bfc60000b02904f9715cd13cso1933338ybm.3
        for <stable@vger.kernel.org>; Fri, 14 May 2021 22:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sNHIuQYVsWA/7a4mAAkQImBcT2qMojEQX5dVrrYWLcM=;
        b=oMGbgtK3hrH/5fPQWLdrW3KsbCwX3axogu6RA7twsgK5yjdE+4mL5hNjbVbEKnkBjT
         mPcgm4zODQ18yFDxmT5Vp3ZE1vdkEetuj1Y+D3itJtG8QwZ5Rufa1kuztrtCRWv57gxz
         C7TfWeSmBTZy9f9weM0S3xUSONdocKJUBwY3tp63YWWAjKipKzovYikfyX3rvzfkCUbs
         GZJh8jStGvIKLqDvCncenDCQfVskSZqvR0kxghS6cWM2++iD+gc633rap5yBDFpuBZJF
         q5QsTI1zSkl5lcoSbhjlAnYGuP4N7yQH5e6/glIh7kt3N11KIjeinMgWFvJ4Fj+ysMhc
         lpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sNHIuQYVsWA/7a4mAAkQImBcT2qMojEQX5dVrrYWLcM=;
        b=H60CkqgUh+cq5/NyYb/ihHZawwIjGFKtl19dQjG5O7of8x/pgfqfKH2/CcyUyj1xyQ
         cImMu2UF0mwzkoLaesQUNLI+cnFLYZzCIhIB4ni+34isoFjzSDL7M2z8rO6/rGum0hCv
         yWuUOwE4j+8hnvsUEHEz+uUSpzyZNgJcqCj43JH3apnboNZz3Fq4Mt5Y7ttdQrE3BzjY
         hGMV1rByn/tw6IMKebOa3WilpMXu1eq187csLeKDClwj/ilzlDtsSD/n9Fw2Tm+uxivx
         fYUt1XBcZ+YZfvpATKym3ujP2ScRbvDLEBAjpjOj4xLl8mO5/f5td3OVtm1s5aj389g+
         WOgw==
X-Gm-Message-State: AOAM533xBYIa+tEC+FwhribaK9cRL+wJSWOtd/YIuWvuyWYTH2hDTYTb
        ctJ77RjbuOAQHL0UOpUlmwFI23qCQ7I=
X-Google-Smtp-Source: ABdhPJwk0WyQnMdHJuZpEfbU+WKgE802VKw+8Tif87zivPDmE0aWIgkLjkHBEvy6pZ5/rwWz3eMx86YyjYA=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:6bd1:251e:e226:7071])
 (user=badhri job=sendgmr) by 2002:a25:9942:: with SMTP id n2mr70156951ybo.230.1621056377552;
 Fri, 14 May 2021 22:26:17 -0700 (PDT)
Date:   Fri, 14 May 2021 22:26:10 -0700
Message-Id: <20210515052613.3261340-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v1 1/4] usb: typec: tcpm: Fix up PR_SWAP when vsafe0v is signalled
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During PR_SWAP, When TCPM is in PR_SWAP_SNK_SRC_SINK_OFF, vbus is
expected to reach VSAFE0V when source turns of vbus. Do not move
to SNK_UNATTACHED state when this happens.

Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index c4fdc00a3bc8..b93c4c8d7b15 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5114,6 +5114,9 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
 				tcpm_set_state(port, SNK_UNATTACHED, 0);
 		}
 		break;
+	case PR_SWAP_SNK_SRC_SINK_OFF:
+		/* Do nothing, vsafe0v is expected during transition */
+		break;
 	default:
 		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
 			tcpm_set_state(port, SNK_UNATTACHED, 0);
-- 
2.31.1.751.gd2f1c929bd-goog

