Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E868E436269
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhJUNLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 09:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhJUNLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 09:11:36 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2C0C06161C;
        Thu, 21 Oct 2021 06:09:20 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t16so1005004eds.9;
        Thu, 21 Oct 2021 06:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LECEOaMB1G/jWwI9IEg6kx6EfVlOlUadsdIvepR6ADo=;
        b=gnRvGwNwNBSjUKx7RQ9Gpa3xYp8zS8uwlavatUf55lWTcsRDZmJIVsXPbNuYcazH55
         mQMQsRHHmw//d6RirvsNLL5x1IJMfdEi1/CB6s6fgpZapMkq1/hrQ687R/HvtJBDAJtT
         6xz01YbG28uFwfo4Ra5YRGgnH1pTrQWlWpYvwHhuO3hyAxc6zgzAjhj/d/7CISdgR+Fv
         OLQ3h1E2bPxSWPSF5EXr53aDTYMtYcWpT3vuLA03scaY3I6m2cDnMQNTaLOUksy0ZnA/
         O6eTBO0MweOihpynBq2/+wczCzcJyjqi8Mudp7AULfmWvEMiRdv29sLLNa5TGgeD83md
         Jr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LECEOaMB1G/jWwI9IEg6kx6EfVlOlUadsdIvepR6ADo=;
        b=T5caiCMZ5eUJYp3rZimW2Hbo/XVn5t2pUrru7X+ZRGJbYL3xPOxM7jZwoBIyEeN7xH
         3EoJr2bbLZNRLx5lgoZ5GsQwy24lSdjivckdCNO9RtFlOlcEqmveSpnvBlFXau6h7CEp
         pYUQLw3qtopKe/je8WQ9zxsiIbdQkyIoimThtS0TvuUrd3iJsh5UAomI+dtSDhMQLC3C
         3W2GMuzAPzmgKcM3lMkdQEdb5fByu8gxJYGxcfyHa3DhDxV93wy7vuLItXqQ5vM2FWyW
         mbNdC8PUYcyce08ZTB5LFujR22Ovm5IKHBFzijc1q1CKw/fetK9W5/eAqwGZt0+T0YPX
         fN5A==
X-Gm-Message-State: AOAM531YAuicormS3pBxQRsl8bhePOum5D4GAKlAuZdK4EOMSz1D9Nwy
        A5LYtkavbySI8qZgND3H0AO4WOcQhmA=
X-Google-Smtp-Source: ABdhPJyXxI70UbL9XtJH+weCYz849WYcLNzw99qUd3iov1sm5Qv3s0hS8gyHmQfYn9Qq7jo7DA8/Zg==
X-Received: by 2002:a05:6402:1e8e:: with SMTP id f14mr7819119edf.27.1634821757166;
        Thu, 21 Oct 2021 06:09:17 -0700 (PDT)
Received: from xws.localdomain ([194.126.177.11])
        by smtp.gmail.com with ESMTPSA id q6sm126987eds.96.2021.10.21.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 06:09:16 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 3/3] HID: surface-hid: Allow driver matching for target ID 1 devices
Date:   Thu, 21 Oct 2021 15:09:04 +0200
Message-Id: <20211021130904.862610-4-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211021130904.862610-1-luzmaximilian@gmail.com>
References: <20211021130904.862610-1-luzmaximilian@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until now we have only ever seen HID devices with target ID 2. The new
Surface Laptop Studio however uses HID devices with target ID 1. Allow
matching this driver to those as well.

Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 drivers/hid/surface-hid/surface_hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/surface-hid/surface_hid.c b/drivers/hid/surface-hid/surface_hid.c
index daa452367c0b..d4aa8c81903a 100644
--- a/drivers/hid/surface-hid/surface_hid.c
+++ b/drivers/hid/surface-hid/surface_hid.c
@@ -230,7 +230,7 @@ static void surface_hid_remove(struct ssam_device *sdev)
 }
 
 static const struct ssam_device_id surface_hid_match[] = {
-	{ SSAM_SDEV(HID, 0x02, SSAM_ANY_IID, 0x00) },
+	{ SSAM_SDEV(HID, SSAM_ANY_TID, SSAM_ANY_IID, 0x00) },
 	{ },
 };
 MODULE_DEVICE_TABLE(ssam, surface_hid_match);
-- 
2.33.1

