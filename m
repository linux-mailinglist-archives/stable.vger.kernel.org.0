Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD21B394B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVHqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 03:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725907AbgDVHqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 03:46:49 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EBFC03C1A6;
        Wed, 22 Apr 2020 00:46:48 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id g4so1235895ljl.2;
        Wed, 22 Apr 2020 00:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7SXxu2vf3SSgVcaedvI6jG4d6yjlJE+FjFpfJQ4jnEw=;
        b=Uiq4AiFsLfTfDqahAyC38SQf4LZ9ewifZ4YN8XMGKiOpWXnn60eoh2ES+Khfx3DDqg
         tzIBhQXx2HaS1nRNBy5vweYDuoYV0/rC9yOFLp3rsLxlwDyR52jBF3EiKZ+58/Y4Fwt0
         FOjr6LgdiucnzUN5KV3Zamft6d5xHXNTEwXJU31X7tN8+FBY+20PObfeO0tvAFSAe6Ut
         VIfl9Q211/HitXhnA906GqCn3GwbIF+duEz3LLg223cxo+AVg0e1MeYJjKi4LtrMroHH
         gj7ep0UPKcr0IsMwl92Ni8b4kTctakpGIhs4y3MjZGLydMuMjwzJa2Q4vKIQ/hd4cIyA
         FxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SXxu2vf3SSgVcaedvI6jG4d6yjlJE+FjFpfJQ4jnEw=;
        b=SeEwVg31VY0uvsQMA+A2xP+mJBM7PZmCkIRXGWtfP0FB+GzxJSPIqqpm1rr6U5cVpk
         Vo8IigoaBlMYMCQjCKvqAldySbDCNzcIqjvsLua0m6u8Uh+sdOULftQYNjCn/eGXzZGZ
         P9EaEDteMlRIdNHN2oiZ2QjuR5eBFbrR/74l1f77xF7BfmKaHWpgDCSV5hv8J3mE8rSW
         R7cZyprqFQKibldPoIvaNREviyADZqrbvcxwNBElMeteP0o7horisrSe7cn7t+GTT5lV
         DqrirWOvA8tvbnTvRpf7z0EpmhczOJVlZuhhlD+LqnReHMOjyZLCIkd71d1uc4XhSX8c
         BVXg==
X-Gm-Message-State: AGi0PubCR9GI1I3GYHLgUZ5wq9QkdN4zorIBeP6RgXR5esmMjMWg7L35
        aGQDGO4Gz+jLlzvZ5KcjFX8=
X-Google-Smtp-Source: APiQypJmSxI80bak8V4LpFM6NnEw/JYrdLaHdXGosrwksyhWtydwWX4UxaU5VQPUCWbMLCaGCeHJpg==
X-Received: by 2002:a2e:9048:: with SMTP id n8mr4527444ljg.122.1587541607251;
        Wed, 22 Apr 2020 00:46:47 -0700 (PDT)
Received: from luk-pc.lan (host-46-186-7-151.dynamic.mm.pl. [46.186.7.151])
        by smtp.googlemail.com with ESMTPSA id t12sm4051345lfq.71.2020.04.22.00.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 00:46:46 -0700 (PDT)
From:   LuK1337 <priv.luk@gmail.com>
Cc:     Cameron Gutman <aicommander@gmail.com>,
        =?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Fontana <rfontana@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: xpad - Add custom init packet for Xbox One S controllers
Date:   Wed, 22 Apr 2020 09:46:39 +0200
Message-Id: <20200422074641.15839-1-priv.luk@gmail.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <92b71dc5-ddd5-7ffd-65f8-65a6610dfe43@gmail.com>
References: <92b71dc5-ddd5-7ffd-65f8-65a6610dfe43@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Patron <priv.luk@gmail.com>

Sending [ 0x05, 0x20, 0x02, 0x0f, 0x06 ] packet for
Xbox One S controllers fixes an issue where controller
is stuck in Bluetooth mode and not sending any inputs.

Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/input/joystick/xpad.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 6b40a1c68f9f..c77cdb3b62b5 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -458,6 +458,16 @@ static const u8 xboxone_fw2015_init[] = {
 	0x05, 0x20, 0x00, 0x01, 0x00
 };
 
+/*
+ * This packet is required for Xbox One S (0x045e:0x02ea)
+ * and Xbox One Elite Series 2 (0x045e:0x0b00) pads to
+ * initialize the controller that was previously used in
+ * Bluetooth mode.
+ */
+static const u8 xboxone_s_init[] = {
+	0x05, 0x20, 0x00, 0x0f, 0x06
+};
+
 /*
  * This packet is required for the Titanfall 2 Xbox One pads
  * (0x0e6f:0x0165) to finish initialization and for Hori pads
@@ -516,6 +526,8 @@ static const struct xboxone_init_packet xboxone_init_packets[] = {
 	XBOXONE_INIT_PKT(0x0e6f, 0x0165, xboxone_hori_init),
 	XBOXONE_INIT_PKT(0x0f0d, 0x0067, xboxone_hori_init),
 	XBOXONE_INIT_PKT(0x0000, 0x0000, xboxone_fw2015_init),
+	XBOXONE_INIT_PKT(0x045e, 0x02ea, xboxone_s_init),
+	XBOXONE_INIT_PKT(0x045e, 0x0b00, xboxone_s_init),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init1),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init2),
 	XBOXONE_INIT_PKT(0x24c6, 0x541a, xboxone_rumblebegin_init),
-- 
2.26.0

