Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7950383D23
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhEQTWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhEQTWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:22:34 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D7EC06175F
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:21:17 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id s11-20020ac85ecb0000b02901ded4f15245so5835912qtx.22
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WSTZG+Ss5oTMbhW5xlZ+aS48SNwB1nH5u8VKqkHoapw=;
        b=dIq1Cdxw9F3TLvhfUP3VO6aAtoX8bNno3Ceg6ZqRXI+oS1PMIcvl6QXimPr3pf3Zpm
         wIe903i4k0i0qwW2CH0ht67bIqKXnCIGjsFDNnM7yg5gGIc/64vzSzpnJ6uxLsY4e7cG
         TiqlOfssmktWpOg50XlqMqPllu8Yo8O7aMif9Is3vqYHtD2+az3k4DpFMNpq5eLpm5HJ
         4N7En/1GyHgfAPmhL80V8kKY1EdDDZ4HwimLaA27ytKeobh/o1Z5wfFrMywb6jvL9jsH
         83aVg6EhlhA82iiA4QyBZcU6DVAt33b5BjrEsvZxAM/M7cxpTJhQutSkPdjKKcc96WVs
         qGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WSTZG+Ss5oTMbhW5xlZ+aS48SNwB1nH5u8VKqkHoapw=;
        b=U23HjbaYzfQ7e2NRcuMQRD/AlhRRJ/B8lu9wUrXqR87EFRmsEwzKCjmLYk06ZTURLD
         MOyZ9etPLF2lSkudDS0V2ot8+IdGOzLziLA7eGA2D0BkxZUkLzwlpVQonUsQF99qE4Mi
         oweEm8wwRRQ68IIrwnO5glg5eL+dEOTZf0JSO45EZNCVpUci58kbk11GxHhdbh8b1Td3
         pqzt5lxH7WT9SKBAKVIugo9LlIaJ7c4cFQCXpIkcAU3wPDcebIAdD9SwBi2MXnbOZ4Hw
         +ArK5gXW70uI7XOYL3a0qOS43jCdsY2Ng347Qq+kDKvEc+w1tk2RC34iFNz05mM++0YX
         vMsw==
X-Gm-Message-State: AOAM530j8DAmWmTgQrNRexBHlwQG4HyF/TfKqdCBxhrHull0sN6k0Q6d
        Ek2nnx6aEku30xVcZQUMEgzT3MVUTwY=
X-Google-Smtp-Source: ABdhPJyfE/ZBgfcDNqee9SFDjAnTCk0HdmuLR5pY1uqW0l2x15rI1L//Tl0WhHyhUY/QnnNqNs4jC/zZ8ZY=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:b562:7011:fe35:1c9e])
 (user=badhri job=sendgmr) by 2002:a0c:ab88:: with SMTP id j8mr1243811qvb.23.1621279276966;
 Mon, 17 May 2021 12:21:16 -0700 (PDT)
Date:   Mon, 17 May 2021 12:21:09 -0700
Message-Id: <20210517192112.40934-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v2 1/4] usb: typec: tcpm: Fix up PR_SWAP when vsafe0v is signalled
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
expected to reach VSAFE0V when source turns off vbus. Do not move
to SNK_UNATTACHED state when this happens.

Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
Changes since V1:
- Fixed type s/of/off in commit message.
- Added Reviewed-by: Guenter Roeck <linux@roeck-us.net>
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

