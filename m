Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D057138A309
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhETJsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233727AbhETJqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:46:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 508A2613F2;
        Thu, 20 May 2021 09:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503234;
        bh=U3fyrcHCCNg6Ujw55OfZ638vS2vjwcPYCyTNs7gGx2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+WyTYTikx0RE1JNsLs5lBFjRz9hudpdIpeMVQA2g22qgCfhVUJmCpaoJo/RQsGyI
         8DdcwPon0MXJoFwjjIpJng19Y4lPUT0Z3MmYh6tTAnPMUrkkf8fG1cV3GUjDKQsVtB
         F5m0Tq4GdC1WXkqhufywnFcSdjaUeKczmqkCW/ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 129/425] bluetooth: eliminate the potential race condition when removing the HCI controller
Date:   Thu, 20 May 2021 11:18:18 +0200
Message-Id: <20210520092135.675573809@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit e2cb6b891ad2b8caa9131e3be70f45243df82a80 upstream.

There is a possible race condition vulnerability between issuing a HCI
command and removing the cont.  Specifically, functions hci_req_sync()
and hci_dev_do_close() can race each other like below:

thread-A in hci_req_sync()      |   thread-B in hci_dev_do_close()
                                |   hci_req_sync_lock(hdev);
test_bit(HCI_UP, &hdev->flags); |
...                             |   test_and_clear_bit(HCI_UP, &hdev->flags)
hci_req_sync_lock(hdev);        |
                                |
In this commit we alter the sequence in function hci_req_sync(). Hence,
the thread-A cannot issue th.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Cc: Marcel Holtmann <marcel@holtmann.org>
Fixes: 7c6a329e4447 ("[Bluetooth] Fix regression from using default link policy")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_request.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -271,12 +271,16 @@ int hci_req_sync(struct hci_dev *hdev, i
 {
 	int ret;
 
-	if (!test_bit(HCI_UP, &hdev->flags))
-		return -ENETDOWN;
-
 	/* Serialize all requests */
 	hci_req_sync_lock(hdev);
-	ret = __hci_req_sync(hdev, req, opt, timeout, hci_status);
+	/* check the state after obtaing the lock to protect the HCI_UP
+	 * against any races from hci_dev_do_close when the controller
+	 * gets removed.
+	 */
+	if (test_bit(HCI_UP, &hdev->flags))
+		ret = __hci_req_sync(hdev, req, opt, timeout, hci_status);
+	else
+		ret = -ENETDOWN;
 	hci_req_sync_unlock(hdev);
 
 	return ret;


