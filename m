Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCEC49B62A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387401AbiAYOZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578323AbiAYOSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:18:17 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C2FC061757
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:18:14 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k18so20178635wrg.11
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ke2LdEVYwtr3s7/AYKvjZguInORBfCCXIzqBYPm0DVM=;
        b=cktbrep9NyG4XcSniEWlMHmsLbObxg0SCdrGHohVncYGdMPQXfm8eRjjs9LkZ3TFot
         KoItAUF1dkvIztglIQRQ9AJsh3os0Qjj3K1WkGkD/0wYUoA7gKOiJk3j8YTryS711itS
         7L7fJ6zyhHTAVyvwy0CUsqYrgU5vKyrY3UAyOebYabY01ZfnnlsM/4x5h880ULMs74xA
         G0OGnztKSIgs1oMUGpxzoTuB4yW87ez22OX32O0pb8Nn3T2kZnFg3RFCprcF3iQ2n5w5
         Fnp/+U6x23Hq5UE4Zyo9vo0KZYme6Ucvi5wl3Ka/29onlKv3F5yXl9nf77g9oPyko5tL
         20hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ke2LdEVYwtr3s7/AYKvjZguInORBfCCXIzqBYPm0DVM=;
        b=U3C1x3Q/G+6WlqUWLzEwE4g/nZI6++E6LlVvgpIB86gIYjPNS/1Ft9Ej5Gt6vZ1VLk
         tiFL9fq2tjnv0JjLibTvN84Ng6JZeslGyFVmg9k7onKFGEPSIUHvswND9psOb/fzqLEU
         hM11IPe/o90b18F3RS3Q68BYZvl1MftgZXPX5Ig/zz+wTPWj+x4L3rKEn2MNeUb1O93j
         lmd4txb5gab7heeiVPOw6EdkuzcpxnnxE1dtFbiTAN66sx2vxkb8TszXuYB8u8HScRnY
         tbP2UHazz/s1+MG7A9kZxhKs7CfG6nOnkjnzX8EBz+H2z1FWEo9aFqikeFj0RMWT4umO
         bGtA==
X-Gm-Message-State: AOAM532qf00iRVtvANdsrMxVKJqOtsMQPXegDKq99ZDS9v8/yPVcbOe8
        yzIZAUpDs12BWWZGNjTMQKXU32HA4jvUBg==
X-Google-Smtp-Source: ABdhPJz51KwgxdLvUa6feNU9I3WHJFfcnpmesmW4IWhPHwTWJCn+qSHDEkWJFjHa5524p903KgA2fw==
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr15475585wrm.610.1643120292767;
        Tue, 25 Jan 2022 06:18:12 -0800 (PST)
Received: from joneslee-l.roam.corp.google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id bg23sm699740wmb.5.2022.01.25.06.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 06:18:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 4.9 3/3] ion: Do not 'put' ION handle until after its final use
Date:   Tue, 25 Jan 2022 14:18:08 +0000
Message-Id: <20220125141808.1172511-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220125141808.1172511-1-lee.jones@linaro.org>
References: <20220125141808.1172511-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pass_to_user() eventually calls kref_put() on an ION handle which is
still live, potentially allowing for it to be legitimately freed by
the client.

Prevent this from happening before its final use in both ION_IOC_ALLOC
and ION_IOC_IMPORT.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---

NB: Only v4.9 is affected by these issues due to refactoring.

 drivers/staging/android/ion/ion-ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index d47e9b4171e28..a27865b94416b 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -165,10 +165,9 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				     data.allocation.flags, true);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
-		pass_to_user(handle);
 		data.allocation.handle = handle->id;
-
 		cleanup_handle = handle;
+		pass_to_user(handle);
 		break;
 	}
 	case ION_IOC_FREE:
@@ -212,11 +211,12 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 		} else {
+			data.handle.handle = handle->id;
 			handle = pass_to_user(handle);
-			if (IS_ERR(handle))
+			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
-			else
-				data.handle.handle = handle->id;
+				data.handle.handle = 0;
+			}
 		}
 		break;
 	}
-- 
2.35.0.rc0.227.g00780c9af4-goog

