Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF92395B8F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhEaNVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhEaNUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:20:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B82B61374;
        Mon, 31 May 2021 13:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467106;
        bh=4GiqQi3JgBjAB1c9DWsu9c3l4a7uWwb2SWwI45dHiq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LILDSKwKwBs/PLAEEpW2kzjAaFeMq3IvvKgIvMMI4q6Zpx4+OzgFp+mypvMhiqwit
         G06GpFYDqTf+PJcxwYCgjIYmQ6Ts6zVv3xLa4oGU8ukSjO27ZbNFMUPR5NeVPgd7W7
         M1iTKwUFOVOaBffcz2nUWtMs1SAWqtsjh5X2Lu8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 53/54] bluetooth: eliminate the potential race condition when removing the HCI controller
Date:   Mon, 31 May 2021 15:14:19 +0200
Message-Id: <20210531130636.726513004@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
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
[iwamatsu: adjust filename, arguments of __hci_req_sync(). CVE-2021-32399]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -371,12 +371,17 @@ static int hci_req_sync(struct hci_dev *
 {
 	int ret;
 
-	if (!test_bit(HCI_UP, &hdev->flags))
-		return -ENETDOWN;
-
 	/* Serialize all requests */
 	hci_req_lock(hdev);
-	ret = __hci_req_sync(hdev, req, opt, timeout);
+	/* check the state after obtaing the lock to protect the HCI_UP
+	 * against any races from hci_dev_do_close when the controller
+	 * gets removed.
+	 */
+	if (test_bit(HCI_UP, &hdev->flags))
+		ret = __hci_req_sync(hdev, req, opt, timeout);
+	else
+		ret = -ENETDOWN;
+
 	hci_req_unlock(hdev);
 
 	return ret;


