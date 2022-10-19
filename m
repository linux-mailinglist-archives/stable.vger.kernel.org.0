Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC175603D26
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiJSI6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiJSI5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:57:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051EC193EE;
        Wed, 19 Oct 2022 01:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20F016186B;
        Wed, 19 Oct 2022 08:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B58C433C1;
        Wed, 19 Oct 2022 08:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169519;
        bh=lpoonZ2TlVs0iMtpGE/VUE4JhkN9JsM8I1mBYYrYK/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hv1P2c1d6yK2aanKopY2Cd7BD4nIncDvU2xdaTF6zk+px/W/zQBE8vqmIe/oXWZuq
         AO5ggzH+Io5MbO1JBM85rfsqX9pxANId0dhMNIYKXF+/ZU9K0gPOXJ1jKL0tFlkvP7
         A3mZW9oCZIJia03Wj0wEuWjrScpDFWapcTyJovPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+844c7bf1b1aa4119c5de@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 274/862] Bluetooth: avoid hci_dev_test_and_set_flag() in mgmt_init_hdev()
Date:   Wed, 19 Oct 2022 10:26:01 +0200
Message-Id: <20221019083302.138874417@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit f74ca25d6d6629ffd4fd80a1a73037253b57d06b ]

syzbot is again reporting attempt to cancel uninitialized work
at mgmt_index_removed() [1], for setting of HCI_MGMT flag from
mgmt_init_hdev() from hci_mgmt_cmd() from hci_sock_sendmsg() can
race with testing of HCI_MGMT flag from mgmt_index_removed() from
hci_sock_bind() due to lack of serialization via hci_dev_lock().

Since mgmt_init_hdev() is called with mgmt_chan_list_lock held, we can
safely split hci_dev_test_and_set_flag() into hci_dev_test_flag() and
hci_dev_set_flag(). Thus, in order to close this race, set HCI_MGMT flag
after INIT_DELAYED_WORK() completed.

This is a local fix based on mgmt_chan_list_lock. Lack of serialization
via hci_dev_lock() might be causing different race conditions somewhere
else. But a global fix based on hci_dev_lock() should deserve a future
patch.

Link: https://syzkaller.appspot.com/bug?extid=844c7bf1b1aa4119c5de
Reported-by: syzbot+844c7bf1b1aa4119c5de@syzkaller.appspotmail.com
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 3f2893d3c142986a ("Bluetooth: don't try to cancel uninitialized works at mgmt_index_removed()")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 72e6595a71cc..3d1cd0666968 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1050,7 +1050,7 @@ static void discov_off(struct work_struct *work)
 
 static void mgmt_init_hdev(struct sock *sk, struct hci_dev *hdev)
 {
-	if (hci_dev_test_and_set_flag(hdev, HCI_MGMT))
+	if (hci_dev_test_flag(hdev, HCI_MGMT))
 		return;
 
 	BT_INFO("MGMT ver %d.%d", MGMT_VERSION, MGMT_REVISION);
@@ -1065,6 +1065,8 @@ static void mgmt_init_hdev(struct sock *sk, struct hci_dev *hdev)
 	 * it
 	 */
 	hci_dev_clear_flag(hdev, HCI_BONDABLE);
+
+	hci_dev_set_flag(hdev, HCI_MGMT);
 }
 
 static int read_controller_info(struct sock *sk, struct hci_dev *hdev,
-- 
2.35.1



