Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890A43D0013
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhGTQko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 12:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhGTQis (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 12:38:48 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB7C061766;
        Tue, 20 Jul 2021 10:19:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l6so12736142wmq.0;
        Tue, 20 Jul 2021 10:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrT0GVimiR22Fx/oC00xUPVm1qes8xXnFCa7JZmG//k=;
        b=nJ/d3VzUexCS7Zz0IlPXvpCatI2EG0yNQUE/YIBt6JYxsq6YFKQM28YOTpteTd8kla
         6i7aJS6CfJ1+uWgVLEmeKAtXsAmdRMwt5yqwe2+26/7xiHDohhYDzd4IAwk3eGCi9kwl
         OaOIDnm7H7Hzmdi1c2AWy8VbGL3p5LtIilZuqsQ4jvblqvC1dLP76ZbzTBsF137dEA4k
         ZwibZcfDtskaHHDebi+Vy5SHsvlbKlAFiRlf52vk3ZKWno3ZwyAu/KhuwlN92rczjzTU
         0CmpFsFb8O+kXmVSKvndn7TDzVn/3GtOj/iTVtTL04cLG1JKUWnW7Ymq2e7xW33CTWJD
         956Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrT0GVimiR22Fx/oC00xUPVm1qes8xXnFCa7JZmG//k=;
        b=lFiJp0KcZG7xcrFn/BCdyybCTdMj0GyF4MblAaorB4+TLsMeSDUUwlOaaZgJ/t4e/J
         J3v7Pr1Zi7etHGs2v5Scmtow1sTY1ASeTSVr8zNPUwyAIO2l9cZSV2WPDGnf9WKX9ekG
         ettcztG5tl6ErAAUzynuk7XD4LktDtrLXC8RWSImxj+IdnwOH3mL/NhoCi7tPAwqTuAP
         33886EnoW/jWgsIwqxLuBUOfAr9v/Ur1lHg2yaQI8lLbQA1lgFbnaidGq6CLC3QFCl6Y
         skNymvHxVE5LIZoXrpU0Bv2resZ/iy36M95cmmykeTLzKJ0X9mE16AHiqZQ6PN4sbcre
         S0Qw==
X-Gm-Message-State: AOAM531RY8fchmZboeSSh1oA+7XQ1+vL9vOLzNfAQvS4M2hzNEgo8s2p
        Iw/xb0N/aGMZDSdr1o7EUMcKpi57civNW3Jh
X-Google-Smtp-Source: ABdhPJyPIusK9yTUVOZ5mk6MnF2uIV+0k8FbL2ffAaV4/dSoXGHdbHynwSgOlJPCHdoGKXrjtJb90A==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr38120777wmj.56.1626801564904;
        Tue, 20 Jul 2021 10:19:24 -0700 (PDT)
Received: from napoleon2.. ([2a02:908:1984:a6c0::ff60])
        by smtp.gmail.com with ESMTPSA id n18sm23356785wrt.89.2021.07.20.10.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 10:19:24 -0700 (PDT)
From:   Julian Sikorski <belegdol@gmail.com>
X-Google-Original-From: Julian Sikorski <belegdol+github@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org, oneukum@suse.com,
        Julian Sikorski <belegdol+github@gmail.com>
Subject: [PATCH] Add LaCie Rugged USB3-FW to IGNORE_UAS
Date:   Tue, 20 Jul 2021 19:19:10 +0200
Message-Id: <20210720171910.36497-1-belegdol+github@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LaCie Rugged USB3-FW appears to be incompatible with UAS. It generates
errors like:
[ 1151.582598] sd 14:0:0:0: tag#16 uas_eh_abort_handler 0 uas-tag 1 inflight: IN
[ 1151.582602] sd 14:0:0:0: tag#16 CDB: Report supported operation codes a3 0c 01 12 00 00 00 00 02 00 00 00
[ 1151.588594] scsi host14: uas_eh_device_reset_handler start
[ 1151.710482] usb 2-4: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[ 1151.741398] scsi host14: uas_eh_device_reset_handler success
[ 1181.785534] scsi host14: uas_eh_device_reset_handler start

Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index f9677a5ec31b..c35a6db993f1 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -45,6 +45,13 @@ UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Julian Sikorski <belegdol@gmail.com> */
+UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
+		"LaCie",
+		"Rugged USB3-FW",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
-- 
2.31.1

