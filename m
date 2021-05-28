Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D992393F01
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 10:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbhE1Iyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 04:54:31 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:44936 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbhE1Iyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 04:54:31 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 14S8qhcC023293; Fri, 28 May 2021 17:52:44 +0900
X-Iguazu-Qid: 34tMccFKPI69aqbTa1
X-Iguazu-QSIG: v=2; s=0; t=1622191963; q=34tMccFKPI69aqbTa1; m=V0eQkIsu+COYtcuxzbPCqr2ufRRsTeXvaadRqTN/yDo=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1510) id 14S8qZtx010858
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 May 2021 17:52:41 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 796E11000AA;
        Fri, 28 May 2021 17:52:35 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 14S8qZ9U032339;
        Fri, 28 May 2021 17:52:35 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4] bluetooth: eliminate the potential race condition when removing the HCI controller
Date:   Fri, 28 May 2021 17:52:24 +0900
X-TSB-HOP: ON
Message-Id: <20210528085224.1021277-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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
[iwamatsu: adjust filename, arguments of __hci_req_sync(). CVE-2021-32399]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 net/bluetooth/hci_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cc905a4e573253..81a81b9a3c7d00 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -371,12 +371,17 @@ static int hci_req_sync(struct hci_dev *hdev,
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
-- 
2.31.1

