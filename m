Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79187436262
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 15:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhJUNLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 09:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhJUNLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 09:11:33 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E52C061749;
        Thu, 21 Oct 2021 06:09:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y12so340404eda.4;
        Thu, 21 Oct 2021 06:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWhS/VWKVIIu5u4miltvI+qmcq5c4uC9DbdWdhggI74=;
        b=WoEZhEev9dqTz70m5xKBKNf7wHRR7VifKNE72uszia0hVOhHB9JTG0fnwPnTK4KESM
         EDS8crGqRr7wLjRBGcxRmlucVhdcC09WrDR1X/05BqBt4j7ijeVDLKtvRewCEBYZTRTD
         U/6xiRfb49kqLKqmG46TXT+IxAteZuWJMdyx0E/wW6+s0XR/pzhv7mh0fQ/1qlUAw2Ki
         6Mr4SJ/Kmx8k6C+anoLVvJyhL5MkZehfcFXRIvRrrkv/d7qyhdv9R7/Q3ayVOKTi+Xic
         WNd5SjJ/DeNmOz40ejoajBPYBcP8CWWu9JS1a0USnUQZ/v4gU9qS80wm8gSTxb128HYG
         ZWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eWhS/VWKVIIu5u4miltvI+qmcq5c4uC9DbdWdhggI74=;
        b=y/X01+oXK6OPiSuUUbmpWyetNRrNevWCqqxQgZWAmGoRye1ZyTISS2JhiitfrKW+0e
         5OQep7bWCyU8NTZFOnKTMsDpYKfh0zyK92cTTnOmJUm+VRhmInMcJu+rDirZqUIjFNMh
         FwVrQg+OxfFum5oR0hXUeVj4wH4l141kkQ5srsXaH03unYquyaq13gvYGyu53MZSFLz+
         Di3DVHwJgBK6BluvyXzt7tzGognEQMSj9JDrt+hHN2610oMQ09bI3CmQ4rHWZ1SXeX0u
         VOj90AV/NGeMZJfzjIA/jnXyAy7pHCxVYsvJ0oWSILp4OSFkPPVgBd/jYpFTenWtRpWu
         xPZw==
X-Gm-Message-State: AOAM531r20LAH2NEcNvujdsBtpWJKbGFz6seb8r/qSedsaZSrbvrsaCv
        iaazBR1uzdsFV2AkA33XlN4=
X-Google-Smtp-Source: ABdhPJya7JxoJvLdTO8E9eHXLyvVxpJiDn8P8sb9CewYUGQHWqceeK916mRIeer6xLmdg5IroxlHjA==
X-Received: by 2002:a17:906:58c1:: with SMTP id e1mr7249968ejs.327.1634821756171;
        Thu, 21 Oct 2021 06:09:16 -0700 (PDT)
Received: from xws.localdomain ([194.126.177.11])
        by smtp.gmail.com with ESMTPSA id q6sm126987eds.96.2021.10.21.06.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 06:09:15 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/3] HID: surface-hid: Use correct event registry for managing HID events
Date:   Thu, 21 Oct 2021 15:09:03 +0200
Message-Id: <20211021130904.862610-3-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211021130904.862610-1-luzmaximilian@gmail.com>
References: <20211021130904.862610-1-luzmaximilian@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until now, we have only ever seen the REG-category registry being used
on devices addressed with target ID 2. In fact, we have only ever seen
Surface Aggregator Module (SAM) HID devices with target ID 2. For those
devices, the registry also has to be addressed with target ID 2.

Some devices, like the new Surface Laptop Studio, however, address their
HID devices on target ID 1. As a result of this, any target ID 2
commands time out. This includes event management commands addressed to
the target ID 2 REG-category registry. For these devices, the registry
has to be addressed via target ID 1 instead.

We therefore assume that the target ID of the registry to be used
depends on the target ID of the respective device. Implement this
accordingly.

Note that we currently allow the surface HID driver to only load against
devices with target ID 2, so these timeouts are not happening (yet).
This is just a preparation step before we allow the driver to load
against all target IDs.

Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 drivers/hid/surface-hid/surface_hid.c         | 2 +-
 include/linux/surface_aggregator/controller.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/surface-hid/surface_hid.c b/drivers/hid/surface-hid/surface_hid.c
index a3a70e4f3f6c..daa452367c0b 100644
--- a/drivers/hid/surface-hid/surface_hid.c
+++ b/drivers/hid/surface-hid/surface_hid.c
@@ -209,7 +209,7 @@ static int surface_hid_probe(struct ssam_device *sdev)
 
 	shid->notif.base.priority = 1;
 	shid->notif.base.fn = ssam_hid_event_fn;
-	shid->notif.event.reg = SSAM_EVENT_REGISTRY_REG;
+	shid->notif.event.reg = SSAM_EVENT_REGISTRY_REG(sdev->uid.target);
 	shid->notif.event.id.target_category = sdev->uid.category;
 	shid->notif.event.id.instance = sdev->uid.instance;
 	shid->notif.event.mask = SSAM_EVENT_MASK_STRICT;
diff --git a/include/linux/surface_aggregator/controller.h b/include/linux/surface_aggregator/controller.h
index 068e1982ad37..74bfdffaf7b0 100644
--- a/include/linux/surface_aggregator/controller.h
+++ b/include/linux/surface_aggregator/controller.h
@@ -792,8 +792,8 @@ enum ssam_event_mask {
 #define SSAM_EVENT_REGISTRY_KIP	\
 	SSAM_EVENT_REGISTRY(SSAM_SSH_TC_KIP, 0x02, 0x27, 0x28)
 
-#define SSAM_EVENT_REGISTRY_REG \
-	SSAM_EVENT_REGISTRY(SSAM_SSH_TC_REG, 0x02, 0x01, 0x02)
+#define SSAM_EVENT_REGISTRY_REG(tid)\
+	SSAM_EVENT_REGISTRY(SSAM_SSH_TC_REG, tid, 0x01, 0x02)
 
 /**
  * enum ssam_event_notifier_flags - Flags for event notifiers.
-- 
2.33.1

