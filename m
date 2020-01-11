Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8ADB1380A7
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgAKKck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgAKKcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:32:39 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94B420678;
        Sat, 11 Jan 2020 10:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738759;
        bh=h+DilfU6kHt1krojOEu3ChpQZDWEHIBDgWHhAtRI0Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqWNuU1VfXrz8HKzWzMbWBoC+NpkAHctKYraldhD69C9wYc8WWUIkMS7wLNMhGwyi
         8z7PhYtF8g9AN18rXC/5U+4jmMKvXNtyYEn18RnQ7d9qLIrPoPlggPMXGv9iAn7oLH
         CtsaMuNxVmQ3/3PUuVqjuA+03Um7Q7VAkOXSfX8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/165] s390/qeth: fix promiscuous mode after reset
Date:   Sat, 11 Jan 2020 10:50:51 +0100
Message-Id: <20200111094936.280389825@linuxfoundation.org>
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

[ Upstream commit 0f399305cd31e5c813086eaa264f7f47e205c10e ]

When managing the promiscuous mode during an RX modeset, qeth caches the
current HW state to avoid repeated programming of the same state on each
modeset.

But while tearing down a device, we forget to clear the cached state. So
when the device is later set online again, the initial RX modeset
doesn't program the promiscuous mode since we believe it is already
enabled.
Fix this by clearing the cached state in the tear-down path.

Note that for the SBP variant of promiscuous mode, this accidentally
works right now because we unconditionally restore the SBP role while
re-initializing.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 1 +
 drivers/s390/net/qeth_l2_sys.c  | 3 ++-
 drivers/s390/net/qeth_l3_main.c | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4bccdce19b5a..8b7d911dccd8 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -295,6 +295,7 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
+	card->info.promisc_mode = 0;
 }
 
 static int qeth_l2_process_inbound_buffer(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index e2bcb26105a3..fc7101ad84de 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -279,7 +279,8 @@ void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 		return;
 
 	mutex_lock(&card->sbp_lock);
-	if (card->options.sbp.role != QETH_SBP_ROLE_NONE) {
+	if (!card->options.sbp.reflect_promisc &&
+	    card->options.sbp.role != QETH_SBP_ROLE_NONE) {
 		/* Conditional to avoid spurious error messages */
 		qeth_bridgeport_setrole(card, card->options.sbp.role);
 		/* Let the callback function refresh the stored role value. */
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d7bfc7a0e4c0..32385327539b 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1433,6 +1433,7 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 	}
 
 	flush_workqueue(card->event_wq);
+	card->info.promisc_mode = 0;
 }
 
 static void qeth_l3_set_promisc_mode(struct qeth_card *card)
-- 
2.20.1



