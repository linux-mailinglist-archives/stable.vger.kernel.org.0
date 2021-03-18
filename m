Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A0833FFE6
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 07:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhCRGsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 02:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCRGsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 02:48:11 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8711BC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 23:48:10 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id i188so30918217qkd.7
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 23:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NPzU0X2RU1mMrCXDCJ6cwWi9ZR2qCTo5uVmVdqJEkKk=;
        b=Rku8/tqzROu9pO57LZgM7cSqLATEh5ILTEUas/vRWQpkd1KbDWa3hu5eMcFA/WCDL+
         UZPRSQQ5JwNZHC5gPtsEK+bYvNIew1+3JaZOHnd7GSl9S2m3FtfVyAqdESNPy+L6zNYR
         5e91wuFBzi7a+6lhIB2Ob/5EvL4P01u6tpNE4Z0Sx0HqjGr342xMQk7futTNImOa6S9q
         JFDGtwS4Ihi/3xLlCrylo5BoTbpjyiS5TRUMfwSlfiTjJ2BMGSjXLP6IfHy1lL7uVF5U
         sAplus7P21520rStbQh0gfkldaKVKPFi+cPW6hwssyjKkrliKU5isx5XxaJt106MyHy8
         OJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NPzU0X2RU1mMrCXDCJ6cwWi9ZR2qCTo5uVmVdqJEkKk=;
        b=glabg+4E6l84sm7/cTPSp3q0jFNAReONx25NbtajE/+8nRoybqN4xCf8rT4dnKW3bD
         9jkqg7Zvj9jdLbsiBzmF9qE7xn22LdgFIRdbdj/bwnvuBndC2L1J8Eqk0FKOXRtcaz4L
         bDbCjBSasu/kI614JE3wikGp0tB8Gs+1eQ+pemEfUz1dYIDRF8h+YBuiDYoWVk7JQNI0
         aZyz3EaQa117+rz/QiRG/yTYrfVgRPw9miNUPM+NvbXQfa7ffWsHDPn1m0qMJerSINTm
         pNAQERhsJZ96gcdaFnfmCOeolYaBkqeOEscY8hI6/wcZTpDkuWk0Y5ZsWklonwa3VR1D
         kSsg==
X-Gm-Message-State: AOAM531mdmZbhcnUs7IVKFtgSbav94W7flAl1qE1vVCvnmE8Ic2FKlKQ
        tjgss5CEzgG9oxWZ+pNSMCuOj5UXw+E=
X-Google-Smtp-Source: ABdhPJwtBexol5FnXQGFdhM+u67eF/rRCxpo0zUknHBcYO+DVzLuvdBwlOurDER4zadcJFsVF3XKLtNs8nQ=
X-Received: from badhri.mtv.corp.google.com ([2620:15c:211:201:dc6b:2250:2aa4:b316])
 (user=badhri job=sendgmr) by 2002:a05:6214:165:: with SMTP id
 y5mr2842410qvs.59.1616050089714; Wed, 17 Mar 2021 23:48:09 -0700 (PDT)
Date:   Wed, 17 Mar 2021 23:48:05 -0700
Message-Id: <20210318064805.3747831-1-badhri@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v1] usb: typec: tcpm: Skip sink_cap query only when VDM sm is busy
From:   Badhri Jagan Sridharan <badhri@google.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When port partner responds "Not supported" to the DiscIdentity command,
VDM state machine can remain in NVDM_STATE_ERR_TMOUT and this causes
querying sink cap to be skipped indefinitely. Hence check for
vdm_sm_running instead of checking for VDM_STATE_DONE.

Fixes: 8dc4bd073663f ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
---
 drivers/usb/typec/tcpm/tcpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 11d0c40bc47d..39e068d60755 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5219,7 +5219,7 @@ static void tcpm_enable_frs_work(struct kthread_work *work)
 		goto unlock;
 
 	/* Send when the state machine is idle */
-	if (port->state != SNK_READY || port->vdm_state != VDM_STATE_DONE || port->send_discover)
+	if (port->state != SNK_READY || port->vdm_sm_running || port->send_discover)
 		goto resched;
 
 	port->upcoming_state = GET_SINK_CAP;
-- 
2.31.0.rc2.261.g7f71774620-goog

