Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC67641979
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiLCWZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCWZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:25:28 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210511E3C8
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 14:25:28 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F122E3F32E
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670106326;
        bh=HXMCKGyncrnckqij2aOjjMC1movuXs2t2DPx82jdONo=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=H6b91juAq1cpfcP6f+yCBb1e7pNTpXs1H1f58c8HptFRWAAocIwoArAjLnYzPI6p5
         Kk6byG4lkLpcj4xP+FREwyfO3DWxRWHaOhsGizuCddVOPpF+NKC/9ipf5RLFeNUO6w
         yChQQ5bYErjTEI6WUZKC+mYywfxqNm5Rl5xh/aKRmyrMObjiv16A0f5RFgz+DPtt8p
         2kiZlIYxS/hRw8qZ4VcQEHimjer4HZMgoQGFt2hiVMgWNfjRhvQp1iBs9bkTkaTu1M
         RaXjKBKrxr8joqJUmkarUCDhxXE7JOeuAhBHgkqBtYpfg+V0ZBPDWDwEF4L9O50hlS
         KUwclkbO63ohw==
Received: by mail-wm1-f69.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so6088564wmp.9
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 14:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HXMCKGyncrnckqij2aOjjMC1movuXs2t2DPx82jdONo=;
        b=F7acZhmhyQW+frY4kkcdXby+zNiTtZgi4ibmrYvyaYS0AqpJvVuyMD06HFJSRPY5si
         BSB1xsROZrsDiDPHs/KDBfOm3ma1XO/6hGWmw/iM/YW2jlZk0eAUGfat4xGEaB7CXZRi
         MjW5FpgLvfFcnJn/tx37UyHeg39DHhUJqedDfhmX7mNpOUhrtmFkNLoe9liq3+wfTqOy
         fIeYRsauz6QvOP25OFs9faFJTcfr8FTHR85stTU/oCY2Anx/L2x+cBQUmMc9ffTac14i
         UvOIJaC1ihfkHwSqTmDbbyiW/ANu9c2pfI6+yt2jw6FXyvnm4bNn1VXMJ2bkcgagQvHF
         mSLg==
X-Gm-Message-State: ANoB5pl+UPir21zfdUhAyZvZaHMzE4kWjPD8YwxmagqFrUYNMwgFtelc
        hIjgcQh7BVSDu3t8YSnfZSU0C/xHr+0GED1ZmuyfQ5HmoI6/2h5pNvTMoiEXh/RplO9f5RD9ro3
        0dYM5APdbiArNdCPB+c4eFDI+9nATd0S7gQ==
X-Received: by 2002:a7b:ca49:0:b0:3c8:353b:2553 with SMTP id m9-20020a7bca49000000b003c8353b2553mr54606030wml.18.1670106326461;
        Sat, 03 Dec 2022 14:25:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf77H0yKhCIxgaXUZAp09RdCdIrazdtbzZtS5MElq2e9PQGRmgZMtqGLQWPiU7HE+dHHMr9fBg==
X-Received: by 2002:a7b:ca49:0:b0:3c8:353b:2553 with SMTP id m9-20020a7bca49000000b003c8353b2553mr54606019wml.18.1670106326173;
        Sat, 03 Dec 2022 14:25:26 -0800 (PST)
Received: from localhost ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id z12-20020a5d44cc000000b002362f6fcaf5sm10418969wrr.48.2022.12.03.14.25.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 14:25:25 -0800 (PST)
From:   Cengiz Can <cengiz.can@canonical.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 2/3] Bluetooth: L2CAP: Add definitions for Enhanced Credit Based Mode
Date:   Sun,  4 Dec 2022 01:24:37 +0300
Message-Id: <20221203222434.669854-3-cengiz.can@canonical.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221203222434.669854-1-cengiz.can@canonical.com>
References: <20221203222434.669854-1-cengiz.can@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 145720963b6c68d0c4054112c09050995259b8f8 upstream

This introduces the definitions for the new L2CAP mode called Enhanced
Credit Based Mode.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: Cengiz Can <cengiz.can@canonical.com>
---
 include/net/bluetooth/l2cap.h | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 21744c30f546..3d44dd73477c 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -119,6 +119,10 @@ struct l2cap_conninfo {
 #define L2CAP_LE_CONN_REQ	0x14
 #define L2CAP_LE_CONN_RSP	0x15
 #define L2CAP_LE_CREDITS	0x16
+#define L2CAP_ECRED_CONN_REQ	0x17
+#define L2CAP_ECRED_CONN_RSP	0x18
+#define L2CAP_ECRED_RECONF_REQ	0x19
+#define L2CAP_ECRED_RECONF_RSP	0x1a
 
 /* L2CAP extended feature mask */
 #define L2CAP_FEAT_FLOWCTL	0x00000001
@@ -361,6 +365,7 @@ struct l2cap_conf_rfc {
  * ever be used in the BR/EDR configuration phase.
  */
 #define L2CAP_MODE_LE_FLOWCTL	0x80
+#define L2CAP_MODE_EXT_FLOWCTL	0x81
 
 struct l2cap_conf_efs {
 	__u8	id;
@@ -485,6 +490,39 @@ struct l2cap_le_credits {
 	__le16     credits;
 } __packed;
 
+#define L2CAP_ECRED_MIN_MTU		64
+#define L2CAP_ECRED_MIN_MPS		64
+
+struct l2cap_ecred_conn_req {
+	__le16 psm;
+	__le16 mtu;
+	__le16 mps;
+	__le16 credits;
+	__le16 scid[0];
+} __packed;
+
+struct l2cap_ecred_conn_rsp {
+	__le16 mtu;
+	__le16 mps;
+	__le16 credits;
+	__le16 result;
+	__le16 dcid[0];
+};
+
+struct l2cap_ecred_reconf_req {
+	__le16 mtu;
+	__le16 mps;
+	__le16 scid[0];
+} __packed;
+
+#define L2CAP_RECONF_SUCCESS		0x0000
+#define L2CAP_RECONF_INVALID_MTU	0x0001
+#define L2CAP_RECONF_INVALID_MPS	0x0002
+
+struct l2cap_ecred_reconf_rsp {
+	__le16 result;
+} __packed;
+
 /* ----- L2CAP channels and connections ----- */
 struct l2cap_seq_list {
 	__u16	head;
@@ -728,6 +766,7 @@ enum {
 	FLAG_EFS_ENABLE,
 	FLAG_DEFER_SETUP,
 	FLAG_LE_CONN_REQ_SENT,
+	FLAG_ECRED_CONN_REQ_SENT,
 	FLAG_PENDING_SECURITY,
 	FLAG_HOLD_HCI_CONN,
 };
-- 
2.37.2

