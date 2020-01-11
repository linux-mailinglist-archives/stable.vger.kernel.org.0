Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DD21380A5
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgAKKcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgAKKce (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:32:34 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B363D20842;
        Sat, 11 Jan 2020 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738753;
        bh=Ws2kN9BbkRqrnW6AyjB0NMQbX1idR9hGWOO/xpgpX9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkP//0ju4qJ1GGLPvhItmhcVRidlbUtaCZAnlJhmeq3iaGpFZXpUL+VVHj8bmfmpP
         B1eoadj8DvOU6M8XKe14gua+1Urb3jATmnoW5LAfALdkh2JkyR9v/rtxUjLbYjuMxO
         wSE54eXtW+Cmez0xp1SzzX5D3BSZwh+zGrIKxVv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/165] s390/qeth: handle error due to unsupported transport mode
Date:   Sat, 11 Jan 2020 10:50:50 +0100
Message-Id: <20200111094936.044321045@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 2e3d7fa5d29b7ab649fdf8f9533ae0c0888a7fac ]

Along with z/VM NICs, there's additional device types that only support
a specific transport mode (eg. external-bridged IQD).
Identify the corresponding error code, and raise a fitting error message
so that the user knows to adjust their device configuration.

On top of that also fix the subsequent error path, so that the rejected
cmd doesn't need to wait for a timeout but gets cancelled straight away.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 14 +++++++-------
 drivers/s390/net/qeth_core_mpc.h  |  5 +++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 83794d7494d4..9df47421d69c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -653,17 +653,17 @@ static int qeth_check_idx_response(struct qeth_card *card,
 	unsigned char *buffer)
 {
 	QETH_DBF_HEX(CTRL, 2, buffer, QETH_DBF_CTRL_LEN);
-	if ((buffer[2] & 0xc0) == 0xc0) {
+	if ((buffer[2] & QETH_IDX_TERMINATE_MASK) == QETH_IDX_TERMINATE) {
 		QETH_DBF_MESSAGE(2, "received an IDX TERMINATE with cause code %#04x\n",
 				 buffer[4]);
 		QETH_CARD_TEXT(card, 2, "ckidxres");
 		QETH_CARD_TEXT(card, 2, " idxterm");
-		QETH_CARD_TEXT_(card, 2, "  rc%d", -EIO);
-		if (buffer[4] == 0xf6) {
+		QETH_CARD_TEXT_(card, 2, "rc%x", buffer[4]);
+		if (buffer[4] == QETH_IDX_TERM_BAD_TRANSPORT ||
+		    buffer[4] == QETH_IDX_TERM_BAD_TRANSPORT_VM) {
 			dev_err(&card->gdev->dev,
-			"The qeth device is not configured "
-			"for the OSI layer required by z/VM\n");
-			return -EPERM;
+				"The device does not support the configured transport mode\n");
+			return -EPROTONOSUPPORT;
 		}
 		return -EIO;
 	}
@@ -740,10 +740,10 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 	case 0:
 		break;
 	case -EIO:
-		qeth_clear_ipacmd_list(card);
 		qeth_schedule_recovery(card);
 		/* fall through */
 	default:
+		qeth_clear_ipacmd_list(card);
 		goto out;
 	}
 
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 6420b58cf42b..b7c17b5c823b 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -912,6 +912,11 @@ extern unsigned char IDX_ACTIVATE_WRITE[];
 #define QETH_IDX_ACT_ERR_AUTH		0x1E
 #define QETH_IDX_ACT_ERR_AUTH_USER	0x20
 
+#define QETH_IDX_TERMINATE		0xc0
+#define QETH_IDX_TERMINATE_MASK		0xc0
+#define QETH_IDX_TERM_BAD_TRANSPORT	0x41
+#define QETH_IDX_TERM_BAD_TRANSPORT_VM	0xf6
+
 #define PDU_ENCAPSULATION(buffer) \
 	(buffer + *(buffer + (*(buffer + 0x0b)) + \
 	 *(buffer + *(buffer + 0x0b) + 0x11) + 0x07))
-- 
2.20.1



