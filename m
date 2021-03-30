Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C6834DDA2
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 03:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhC3BhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 21:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhC3Bg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 21:36:56 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2EDC0613D8
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:36:56 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r193so14740650ior.9
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3F9Ll0qnSxDDddAOx0jqTjf+DiNaHm+WnTfsee7Z5qE=;
        b=STwWa5iIWBQnuXyByFcWblI5Yuw6ryaNi8aFcux+kT6rU8ycSq7bfx2bfmwAiUo3+T
         cexk4q1oE5HuSARupJhYrPx/AtOLP1mJN6950ZRCMzw34JX/fcKoRiXMebdNK+OdVdqX
         hkQq9E0x9ZwnkUfOjtAg+2yotMhjWoKEMoe+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3F9Ll0qnSxDDddAOx0jqTjf+DiNaHm+WnTfsee7Z5qE=;
        b=WP+7hX+3u5DgpTMsmxt0Svpv31qKWvUpSLZNggxoT+QLrJA1xkgWI5AOfGY3zUeVlK
         T7xkGwQ2wyElu9kvvOFaD8T7nrLGJOReLDip0V/Eg840GyAWP1g3jcJSkRoTkTpj4fex
         ApYYuvWKPgvV7tHmRZBafBZM8qmb2HbDOHsie5IKnJB+1UKJIN1bcwaq2xkrawdLFM82
         BOBPaGZd239Fx2jalBivJQzIy5LKmZAXXivWEp55JaXsqUWmgI+Al49ZwE6qY6QgHTMt
         Whyg900E0Ze/kXOj8A58Kgc+uOM8XQsaoOgAZ2nP1sxanOnBLDNvh5ALxu5LxA2S2TAo
         VUHg==
X-Gm-Message-State: AOAM532ORaMuG/JY6+x1b24Ut98DMg51Zad9SO00kUHLYsRBLJanS0eC
        LF34CKNPt9AI2sbFB0vtdpxk/A==
X-Google-Smtp-Source: ABdhPJxk7i3YAI4U7l+ZaD3kv7Ww8QwZ8r2xWDlq9TXLeehfGxAmiyDBUuENs49ZQjNY1w/c8/z1Cw==
X-Received: by 2002:a5d:9250:: with SMTP id e16mr22642440iol.27.1617068215710;
        Mon, 29 Mar 2021 18:36:55 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i13sm10551696ilm.86.2021.03.29.18.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:36:55 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     valentina.manea.m@gmail.com, shuah@kernel.org,
        gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH 4/4] usbip: synchronize event handler with sysfs code paths
Date:   Mon, 29 Mar 2021 19:36:51 -0600
Message-Id: <c5c8723d3f29dfe3d759cfaafa7dd16b0dfe2918.1616807117.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1616807117.git.skhan@linuxfoundation.org>
References: <cover.1616807117.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to synchronize event handler with sysfs paths
in usbip drivers.

Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/usb/usbip/usbip_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
index 5d88917c9631..086ca76dd053 100644
--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -70,6 +70,7 @@ static void event_handler(struct work_struct *work)
 	while ((ud = get_event()) != NULL) {
 		usbip_dbg_eh("pending event %lx\n", ud->event);
 
+		mutex_lock(&ud->sysfs_lock);
 		/*
 		 * NOTE: shutdown must come first.
 		 * Shutdown the device.
@@ -90,6 +91,7 @@ static void event_handler(struct work_struct *work)
 			ud->eh_ops.unusable(ud);
 			unset_event(ud, USBIP_EH_UNUSABLE);
 		}
+		mutex_unlock(&ud->sysfs_lock);
 
 		wake_up(&ud->eh_waitq);
 	}
-- 
2.27.0

