Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6C83629AA
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbhDPUyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbhDPUyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:54:11 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9050C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:45 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id i81so29166642oif.6
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1XWPGM8zhiAwM9m1K9VVuFeSk75gHnDuWWcf0KSQw9E=;
        b=BEMwozo2p1Qb5DJ1yFaf70tsoQ1EdgA/Xd6HkUWN3RVqUXm9At3m4xnxUys+Vh0nbq
         crPkfQvAiTjxtvifizJx8EN3aqf9TmvaueawZ9MCa4ow0weL4t7d79rnmNlxVaNTatOI
         zRnz6fQm/G+UyVa/wW9mQ/B4Ha2HiSMMd2hhUaUzIjwLduXLRPvyq60LTaMUrYP6OybD
         z8mp2/ooCQHe4QNvVF43/H0PXmTTqbHHZJdnzbLvjrnHRZs0GJUk0yNQHjYDg26haWN5
         tZcB1id4JPOwkRkNnSi+O9CHoffpC603qvFlYczQ9j+Rlx0yxLRPGFucMSI5uxpDd4wq
         9mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1XWPGM8zhiAwM9m1K9VVuFeSk75gHnDuWWcf0KSQw9E=;
        b=PxUCTFsWWW3h7zREDUSFVIGlF9SA9acD0FzKzSO8GKy0zOkSdErb5KewvA5z1JmLsf
         X4pdOGPlY2CAQgmD1JIEHugJaO0TFBKClIRYDzc4L4f+5pXMCheJPXww4F3eyIC3m/G5
         k0QgTCxx4K2neKXrXJ0zVW96GdIwnd3bHfiBfo+jMIRdolgLiJujQZ2wxR8Ht1fSekQO
         7melORBrMeWnCHKersN7WAv3MYozODQT5ozQXzmDmLpGGQAdmtne6bCfN+/2M8ZngBVP
         7qY5hfOFqyVtTFxS9GKHth5NW6N2o7tiVe5+HS8drZLdJlWhpvM2R0pufp2uTNf0Mx0T
         MmUQ==
X-Gm-Message-State: AOAM530oVPPE7ZbrIgIzm9K8bREPMzPI7zmkJbiPeqB7w8LRaROGx8PC
        y84DgtfiRP18AuHgWvYvAUIMbHSlw04IhTDY
X-Google-Smtp-Source: ABdhPJz44GgSua6mHpfFkvr4/NabMe/EzBlyRjO1TGYsPuXreIVTkI+MT6hXIwJKL3EdaJNMOKI0Jw==
X-Received: by 2002:aca:aa8b:: with SMTP id t133mr7835515oie.150.1618606424823;
        Fri, 16 Apr 2021 13:53:44 -0700 (PDT)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id c21sm1440847ooa.48.2021.04.16.13.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:53:44 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH 4/4] usbip: synchronize event handler with sysfs code paths
Date:   Fri, 16 Apr 2021 15:53:19 -0500
Message-Id: <20210416205319.14075-4-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210416205319.14075-1-tseewald@gmail.com>
References: <20210416205319.14075-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814 upstream.

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to synchronize event handler with sysfs paths
in usbip drivers.

Cc: stable@vger.kernel.org # 4.9.x
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/c5c8723d3f29dfe3d759cfaafa7dd16b0dfe2918.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/usb/usbip/usbip_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
index f8f7f3803a99..01eaae1f265b 100644
--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -84,6 +84,7 @@ static void event_handler(struct work_struct *work)
 	while ((ud = get_event()) != NULL) {
 		usbip_dbg_eh("pending event %lx\n", ud->event);
 
+		mutex_lock(&ud->sysfs_lock);
 		/*
 		 * NOTE: shutdown must come first.
 		 * Shutdown the device.
@@ -104,6 +105,7 @@ static void event_handler(struct work_struct *work)
 			ud->eh_ops.unusable(ud);
 			unset_event(ud, USBIP_EH_UNUSABLE);
 		}
+		mutex_unlock(&ud->sysfs_lock);
 
 		wake_up(&ud->eh_waitq);
 	}
-- 
2.20.1

