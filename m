Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBFF5AEC19
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbiIFOUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242222AbiIFOT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:19:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADBA2AE37;
        Tue,  6 Sep 2022 06:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB848B81637;
        Tue,  6 Sep 2022 13:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44616C433B5;
        Tue,  6 Sep 2022 13:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471887;
        bh=jdvlzF5PiHiRYG83O8c8MTkP5A5o4KJw3TjhC8W2X9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3HAh4pizJ9q/KgHr8UkcDp4ctK33AU+CeoxRz25M82MjaHmJGYmW3ZliKrbQe4SL
         wLWlmqtYKGxnP9ZgeA8Zg8QkHVD49SIHryc7CQPKrUrAuEdwF3cyyEQFfBkijVT+h/
         D1Xt5B8IDe4TYf4HUpBOBE6Y8OPiHDBmz8SjUO6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengping Jiang <jiangzp@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 032/155] Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn
Date:   Tue,  6 Sep 2022 15:29:40 +0200
Message-Id: <20220906132830.787518784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengping Jiang <jiangzp@google.com>

[ Upstream commit 2da8eb834b775a9d1acea6214d3e4a78ac841e6e ]

When disconnecting all devices, hci_conn_failed is used to cleanup
hci_conn object when the hci_conn object cannot be aborted.
The function hci_conn_failed requires the caller holds hdev->lock.

Fixes: 9b3628d79b46f ("Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 2012f23158839..3b4cee67bbd60 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4452,9 +4452,11 @@ static int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
 		/* Cleanup hci_conn object if it cannot be cancelled as it
 		 * likelly means the controller and host stack are out of sync.
 		 */
-		if (err)
+		if (err) {
+			hci_dev_lock(hdev);
 			hci_conn_failed(conn, err);
-
+			hci_dev_unlock(hdev);
+		}
 		return err;
 	case BT_CONNECT2:
 		return hci_reject_conn_sync(hdev, conn, reason);
-- 
2.35.1



