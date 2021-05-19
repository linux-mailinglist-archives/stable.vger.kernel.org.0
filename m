Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285533894D4
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 19:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhESR4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 13:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhESR4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 13:56:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BF6C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 10:55:13 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p6so7480287plr.11
        for <stable@vger.kernel.org>; Wed, 19 May 2021 10:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wnCRSwEx9htYKBS/cDc9ReUAFzUaKLXqNcbYMxcziz0=;
        b=HwIQUrYfBgusWoiQP4v2wSdmf5xpzDm9ix/IhMaYSL5Wu+f8xME4/68OjDVjt31JeN
         BHwOkBQeI3VXGoEnOZh+K4dDhkAJ/jQ8MpuuN4DDurYfqspStadqGyqrg4M1R0HeysHw
         jYbICUR0mD12QKXO8f3Gv5ZwJHGj3bsUyEKNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wnCRSwEx9htYKBS/cDc9ReUAFzUaKLXqNcbYMxcziz0=;
        b=cHM3qgXOUgPlm5jukbdDPNaBoTtPTIGojb7To5BVCNNTiJOqLUn0yysPAuapDA+pA4
         MQVfTK2GfRcRDpHWhTNHcFKjR2v2QmmS9jK15b0QfQwitY0iLkMsMLN9DehcRoYGWEVg
         0B3eUPKgC+2+NtXq0/Bj/Epx69WYwSEuryMMIl3+tNZQ7X4G5ShvWT47/fvB+b0I2PoO
         UzQK5qGmaXExHDAetvFhcDh02mdmfKgZ4B3mtP2M463wnU13/uLsOI2IOkWSupDMP+ln
         hGMgOrPiMxZtLhmQDtiL21QfktGhlkTZVqmTqM0uQRWLq9gs43N8J0WRnNBtzz1a8nNt
         SdAw==
X-Gm-Message-State: AOAM530d0ayT4TDnyuvplhTx2bOFPa3Mysq+iFRi/WdPxrqL2eAfPMio
        aoGX0E+emiBjYJNQvWPfemP42wxg8CcJcw==
X-Google-Smtp-Source: ABdhPJxAYcUannnk8hHJ5sVYDNL7MRyKRLTv0J/mV+E1x3E8wJ1m2uXgplwzCqlLsmUha6oVMvTbSg==
X-Received: by 2002:a17:90b:a18:: with SMTP id gg24mr542017pjb.188.1621446912443;
        Wed, 19 May 2021 10:55:12 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:ac3f:df42:ff1f:5f2a])
        by smtp.googlemail.com with ESMTPSA id mt24sm119168pjb.18.2021.05.19.10.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 10:55:12 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        apusaka@chromium.org, luiz.von.dentz@intel.com, marcel@holtmann.org
Subject: [v5.4.y] Bluetooth: L2CAP: Fix handling LE modes by L2CAP_OPTIONS
Date:   Wed, 19 May 2021 10:55:02 -0700
Message-Id: <20210519175502.602799-1-zsm@chromium.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

L2CAP_OPTIONS shall only be used with BR/EDR modes.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
(cherry picked from commit b86b0b150fed840c376145383ef5105116c81b0c)
Signed-off-by: Zubin Mithra <zsm@chromium.org>
---
* Syzkaller triggered a GPF with the following stacktrace:
 l2cap_chan_send+0xa6e/0x1c30 net/bluetooth/l2cap_core.c:2532
 l2cap_sock_sendmsg+0x1da/0x1fd net/bluetooth/l2cap_sock.c:985
 sock_sendmsg_nosec+0x88/0xb4 net/socket.c:638
 sock_sendmsg+0x5e/0x6f net/socket.c:658
 ____sys_sendmsg+0x45c/0x5a5 net/socket.c:2298
 ___sys_sendmsg+0x13e/0x19f net/socket.c:2352
 __sys_sendmmsg+0x298/0x38c net/socket.c:2455
 __do_sys_sendmmsg net/socket.c:2484 [inline]
 __se_sys_sendmmsg net/socket.c:2481 [inline]
 __x64_sys_sendmmsg+0xad/0xb6 net/socket.c:2481
 do_syscall_64+0x10b/0x144 arch/x86/entry/common.c:299
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

* This commit is present in 5.10.y and newer. 4.19.y
and older do not need this fix.

* This patch resolves conflicts that arise due to a BT_DBG()
introduced in the following commit not being present in linux-5.4.y:
- 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")

* Tests run: syzkaller reproducer, Chrome OS tryjobs

 net/bluetooth/l2cap_sock.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 8648c5211ebe..e43da778c993 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -418,6 +418,20 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 			break;
 		}
 
+		/* Only BR/EDR modes are supported here */
+		switch (chan->mode) {
+		case L2CAP_MODE_BASIC:
+		case L2CAP_MODE_ERTM:
+		case L2CAP_MODE_STREAMING:
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+
+		if (err < 0)
+			break;
+
 		memset(&opts, 0, sizeof(opts));
 		opts.imtu     = chan->imtu;
 		opts.omtu     = chan->omtu;
@@ -677,10 +691,8 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 			break;
 		}
 
-		chan->mode = opts.mode;
-		switch (chan->mode) {
-		case L2CAP_MODE_LE_FLOWCTL:
-			break;
+		/* Only BR/EDR modes are supported here */
+		switch (opts.mode) {
 		case L2CAP_MODE_BASIC:
 			clear_bit(CONF_STATE2_DEVICE, &chan->conf_state);
 			break;
@@ -694,6 +706,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 			break;
 		}
 
+		if (err < 0)
+			break;
+
+		chan->mode = opts.mode;
 		chan->imtu = opts.imtu;
 		chan->omtu = opts.omtu;
 		chan->fcs  = opts.fcs;
-- 
2.20.0

