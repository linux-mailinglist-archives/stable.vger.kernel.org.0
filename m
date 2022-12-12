Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8142C64A10D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiLLNep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiLLNeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:34:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04DB13EAA
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DED3B80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368A8C433EF;
        Mon, 12 Dec 2022 13:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852057;
        bh=jnA/pjxNnmu5e2OhvOQLP5yyl66x3suQ6xdgemsaMrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/BQXNd1esmduXPwtPNa+xONOqhU+x/FJsPIF/uEhI2scsJnfHxcLNBjx64IGld5M
         vwmD6D1yK+MSNxPEQCEAuvdXZjEONYtHReReUqEyWbWUfc1uo5Qt4uhyQhwKUnkW6S
         SA3ktG2HuNaJNBNpn//4BH6yqsJGtrbrFKMmfxg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/123] s390/qeth: fix various format strings
Date:   Mon, 12 Dec 2022 14:18:04 +0100
Message-Id: <20221212130932.318053285@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 22e2b5cdb0b9b59d4df6da5ca9bc5773a4f8e3ea ]

Various format strings don't match with types of parameters.
Fix all of them.

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ebaaadc332cd ("s390/qeth: fix use-after-free in hsci")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index dc6c00768d91..dbe0ef11028b 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -661,13 +661,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "andelmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(ntfy_mac));
 	} else {
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "anaddmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(ntfy_mac));
 	}
 }
 
@@ -765,8 +765,8 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	int err = 0;
 
 	kfree(br2dev_event_work);
-	QETH_CARD_TEXT_(card, 4, "b2dw%04x", event);
-	QETH_CARD_TEXT_(card, 4, "ma%012lx", ether_addr_to_u64(addr));
+	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
+	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
 	rcu_read_lock();
 	/* Verify preconditions are still valid: */
@@ -795,7 +795,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 				if (err) {
 					QETH_CARD_TEXT(card, 2, "b2derris");
 					QETH_CARD_TEXT_(card, 2,
-							"err%02x%03d", event,
+							"err%02lx%03d", event,
 							lowerdev->ifindex);
 				}
 			}
@@ -813,7 +813,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 			break;
 		}
 		if (err)
-			QETH_CARD_TEXT_(card, 2, "b2derr%02x", event);
+			QETH_CARD_TEXT_(card, 2, "b2derr%02lx", event);
 	}
 
 unlock:
@@ -878,7 +878,7 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 	while (lowerdev) {
 		if (qeth_l2_must_learn(lowerdev, dstdev)) {
 			card = lowerdev->ml_priv;
-			QETH_CARD_TEXT_(card, 4, "b2dqw%03x", event);
+			QETH_CARD_TEXT_(card, 4, "b2dqw%03lx", event);
 			rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
 						       dstdev, event,
 						       fdb_info->addr);
-- 
2.35.1



