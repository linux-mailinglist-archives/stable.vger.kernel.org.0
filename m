Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00E92788A8
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgIYMuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgIYMt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76B1D21741;
        Fri, 25 Sep 2020 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038199;
        bh=Jj10ls3O0nnpW9rQmod1La/8TeoBAluz096y6T0bLO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrUrtqyCji7NfmHEM0xrP5uTc3YRRmfTAxRq/TZB3iT1Y+eHIejzlnOGV06jrL4RE
         HbFWwb4zAOLgF5Z0a8wJ25fVNSFHuWF1eyArF/+3dBbach35XODAkX26CJ8wf4SY3w
         A9J7IVPriOexbz656Dqialz9L/sPXAW4mPfCZNDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 10/56] hinic: bump up the timeout of SET_FUNC_STATE cmd
Date:   Fri, 25 Sep 2020 14:48:00 +0200
Message-Id: <20200925124729.369708985@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 4e4269ebe7e18038fffacf113e2dd5ded6d49942 ]

We free memory regardless of the return value of SET_FUNC_STATE
cmd in hinic_close function to avoid memory leak and this cmd may
timeout when fw is busy with handling other cmds, so we bump up the
timeout of this cmd to ensure it won't return failure.

Fixes: 00e57a6d4ad3 ("net-next/hinic: Add Tx operation")
Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -45,6 +45,8 @@
 
 #define MGMT_MSG_TIMEOUT                5000
 
+#define SET_FUNC_PORT_MBOX_TIMEOUT	30000
+
 #define SET_FUNC_PORT_MGMT_TIMEOUT	25000
 
 #define mgmt_to_pfhwdev(pf_mgmt)        \
@@ -358,16 +360,20 @@ int hinic_msg_to_mgmt(struct hinic_pf_to
 		return -EINVAL;
 	}
 
-	if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
-		timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+	if (HINIC_IS_VF(hwif)) {
+		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+			timeout = SET_FUNC_PORT_MBOX_TIMEOUT;
 
-	if (HINIC_IS_VF(hwif))
 		return hinic_mbox_to_pf(pf_to_mgmt->hwdev, mod, cmd, buf_in,
-					in_size, buf_out, out_size, 0);
-	else
+					in_size, buf_out, out_size, timeout);
+	} else {
+		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+			timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+
 		return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
 				buf_out, out_size, MGMT_DIRECT_SEND,
 				MSG_NOT_RESP, timeout);
+	}
 }
 
 static void recv_mgmt_msg_work_handler(struct work_struct *work)


