Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325F2603D50
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiJSJAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiJSI72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD632316E;
        Wed, 19 Oct 2022 01:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6840C61840;
        Wed, 19 Oct 2022 08:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C46C433D6;
        Wed, 19 Oct 2022 08:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169568;
        bh=rMXzGfT+AwXnfRT0f5JD55o8ci30M3mUQCL/5UtoNGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1JV272Bjd1wO+SEr9GEbyUjfVqiol4nCf3vZ/hIs3opzAAdCIhxvt+arZpP+/jWk
         Pd4DzzBZDcZyZsvazB9I2Qo3ueAS26/ghzUMhtBoqQ/d6QMyQ4sav2HfXJMyYTUCgh
         g0p+QDcg0ficca7rdMtFwuwT/n6kDaBzAk8dyoZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 325/862] Bluetooth: Prevent double register of suspend
Date:   Wed, 19 Oct 2022 10:26:52 +0200
Message-Id: <20221019083304.385189903@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit 4b8af331bb4d4cc8bb91c284b11b98dd1e265185 ]

Suspend notifier should only be registered and unregistered once per
hdev. Simplify this by only registering during driver registration and
simply exiting early when HCI_USER_CHANNEL is set.

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 359ee4f834f5 (Bluetooth: Unregister suspend with userchannel)
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 ++++
 net/bluetooth/hci_sock.c | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e6be18eb7fe6..6ae5aa5c0927 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2400,6 +2400,10 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		container_of(nb, struct hci_dev, suspend_notifier);
 	int ret = 0;
 
+	/* Userspace has full control of this device. Do nothing. */
+	if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL))
+		return NOTIFY_DONE;
+
 	if (action == PM_SUSPEND_PREPARE)
 		ret = hci_suspend_dev(hdev);
 	else if (action == PM_POST_SUSPEND)
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 0d015d4a8e41..bd8358b44aa4 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -887,7 +887,6 @@ static int hci_sock_release(struct socket *sock)
 			 */
 			hci_dev_do_close(hdev);
 			hci_dev_clear_flag(hdev, HCI_USER_CHANNEL);
-			hci_register_suspend_notifier(hdev);
 			mgmt_index_added(hdev);
 		}
 
@@ -1216,7 +1215,6 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 		}
 
 		mgmt_index_removed(hdev);
-		hci_unregister_suspend_notifier(hdev);
 
 		err = hci_dev_open(hdev->id);
 		if (err) {
@@ -1231,7 +1229,6 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 				err = 0;
 			} else {
 				hci_dev_clear_flag(hdev, HCI_USER_CHANNEL);
-				hci_register_suspend_notifier(hdev);
 				mgmt_index_added(hdev);
 				hci_dev_put(hdev);
 				goto done;
-- 
2.35.1



