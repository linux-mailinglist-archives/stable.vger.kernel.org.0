Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933D714E1E5
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgA3Ssa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731565AbgA3Ss3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E808720674;
        Thu, 30 Jan 2020 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410109;
        bh=1VhOplUIE/2b6FpqWPVUcG8G4x9V+L2mRc8LS2GNV9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3F7Ssa/Hs84+DDY7U5qI2HBFK7hSv3poXapmYDkod5/OXeDi3A6yGXDt6C7nWpw7
         4bvP5l6/eOhuurxujmfJz7klpcXM3Zl1ySS2zmcz95PMFHTlkBPyMuvOiQjXx3U00T
         /I04eX9VJ/qsqDxxXg4IxOMDuojI1zxHnsL9DA+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 48/55] rsi: fix use-after-free on probe errors
Date:   Thu, 30 Jan 2020 19:39:29 +0100
Message-Id: <20200130183617.236281533@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 92aafe77123ab478e5f5095878856ab0424910da upstream.

The driver would fail to stop the command timer in most error paths,
something which specifically could lead to the timer being freed while
still active on I/O errors during probe.

Fix this by making sure that each function starting the timer also stops
it in all relevant error paths.

Reported-by: syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com
Fixes: b78e91bcfb33 ("rsi: Add new firmware loading method")
Cc: stable <stable@vger.kernel.org>     # 4.12
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_hal.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -616,6 +616,7 @@ static int bl_cmd(struct rsi_hw *adapter
 	bl_start_cmd_timer(adapter, timeout);
 	status = bl_write_cmd(adapter, cmd, exp_resp, &regout_val);
 	if (status < 0) {
+		bl_stop_cmd_timer(adapter);
 		rsi_dbg(ERR_ZONE,
 			"%s: Command %s (%0x) writing failed..\n",
 			__func__, str, cmd);
@@ -731,10 +732,9 @@ static int ping_pong_write(struct rsi_hw
 	}
 
 	status = bl_cmd(adapter, cmd_req, cmd_resp, str);
-	if (status) {
-		bl_stop_cmd_timer(adapter);
+	if (status)
 		return status;
-	}
+
 	return 0;
 }
 
@@ -822,10 +822,9 @@ static int auto_fw_upgrade(struct rsi_hw
 
 	status = bl_cmd(adapter, EOF_REACHED, FW_LOADING_SUCCESSFUL,
 			"EOF_REACHED");
-	if (status) {
-		bl_stop_cmd_timer(adapter);
+	if (status)
 		return status;
-	}
+
 	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
 	return 0;
 }
@@ -846,6 +845,7 @@ static int rsi_load_firmware(struct rsi_
 		status = hif_ops->master_reg_read(adapter, SWBL_REGOUT,
 					      &regout_val, 2);
 		if (status < 0) {
+			bl_stop_cmd_timer(adapter);
 			rsi_dbg(ERR_ZONE,
 				"%s: REGOUT read failed\n", __func__);
 			return status;


