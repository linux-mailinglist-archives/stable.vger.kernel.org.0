Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F40D371361
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 12:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhECKJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 06:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbhECKJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 06:09:03 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92269C06174A;
        Mon,  3 May 2021 03:08:10 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id n138so7274858lfa.3;
        Mon, 03 May 2021 03:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qtxDGmxBhsi2IP7332PQH7tVPfSgkZrPmGm6BEOBEO4=;
        b=X0vzCHQdFjsA7MpwFIDNpKpUMkiFwnAowhcDUr3BjPO9cON/kGIIDy9AyQ7uxsP8u9
         8nHnowrVrsrOXXhyPqyhF0MW0n3dBQo2vUW29UCKJGzbRhylUgCdKBubqRQsZsR5nV4+
         /muAXGWreS5Q8/nefwhh4DsuhoB9jMUJJ+waBlix4kKARlZF5MkKKzeyvVWWTkCajTbx
         hJd65f/vWybEwPyozaLfKE0tNoNA23FtcYnT1zY5QZd7pkTjsgMZCSIRk38mDmuc9Iod
         g+hXCKRcLPuKUGIkzKG4h3CZpb94Mfz+LL/Umrhd/gjcguiLRuoTrx9HXfEYErIPUJtL
         YjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qtxDGmxBhsi2IP7332PQH7tVPfSgkZrPmGm6BEOBEO4=;
        b=aKg60S86MpRHu9L5+Rqosev0rcwkdkcHiy4LqSJ4GldU88jKxLNeQqnASka9cXGpFY
         VnSOjOxsZhkkhN1ZYVKvMVDnsFkESBrnxXFr0dcL7PYBdFyW+xagrhbJgbZ5rgrG37Bx
         RGjqhdDl8RNvDQfig5JZGagY5UGuIuVYd/c3iEGK5CLhkIhiwNZQ7usUAu1W8f2iFwf3
         9QoG6VRTJ71yj+o1nLRj9Sd4wmgs/A7/hStgHSS5iRWQEudUQeLeGhIwMcNRmhY+YwUH
         tMOZppwXp1gZ9z0y4RngeF9LscxALDryg0K6qeXfgBi7Zm/LmCZdDeN4zJqQBRXZ6R21
         TRIQ==
X-Gm-Message-State: AOAM531daV9U5elRleR/gS8eKjCrp/wBdxPVmwEN3klSPzu4HY3p+VSP
        EV0kxvabZcHnxPz7KyE9Vp4=
X-Google-Smtp-Source: ABdhPJy8mZlLiPCStCHJ9xLMBSBC/WR320Gn8cR/tQGSTj+gVzpluZxnH1c/MNCMDFd5KPR9GPdG8Q==
X-Received: by 2002:a05:6512:2021:: with SMTP id s1mr12596618lfs.211.1620036489056;
        Mon, 03 May 2021 03:08:09 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.84])
        by smtp.gmail.com with ESMTPSA id f18sm1092372lft.98.2021.05.03.03.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 03:08:08 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        Rocky Liao <rjliao@codeaurora.org>
Subject: [PATCH v2] bluetooth: hci_qca: fix potential GPF
Date:   Mon,  3 May 2021 13:06:05 +0300
Message-Id: <20210503100605.5223-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YI+s2Hms/56Pvatu@hovoldconsulting.com>
References: <YI+s2Hms/56Pvatu@hovoldconsulting.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In qca_power_shutdown() qcadev local variable is
initialized by hu->serdev.dev private data, but
hu->serdev can be NULL and there is a check for it.

Since, qcadev is not used before

	if (!hu->serdev)
		return;

we can move its initialization after this "if" to
prevent GPF.

Fixes: 5559904ccc08 ("Bluetooth: hci_qca: Add QCA Rome power off support to the qca_power_shutdown()")
Cc: stable@vger.kernel.org # v5.6+
Cc: Rocky Liao <rjliao@codeaurora.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/bluetooth/hci_qca.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index de36af63e182..9589ef6c0c26 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1820,8 +1820,6 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	unsigned long flags;
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 
-	qcadev = serdev_device_get_drvdata(hu->serdev);
-
 	/* From this point we go into power off state. But serial port is
 	 * still open, stop queueing the IBS data and flush all the buffered
 	 * data in skb's.
@@ -1837,6 +1835,8 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	if (!hu->serdev)
 		return;
 
+	qcadev = serdev_device_get_drvdata(hu->serdev);
+
 	if (qca_is_wcn399x(soc_type)) {
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
-- 
2.31.1

