Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9238C4622F2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhK2VJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhK2VHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:07:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80794C125325;
        Mon, 29 Nov 2021 10:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBBADCE13DE;
        Mon, 29 Nov 2021 18:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7825BC53FC7;
        Mon, 29 Nov 2021 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210420;
        bh=A3DQD7crFqu5Uelih0zTvCHfKqxrfC5RrEpTwUuljtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTQjW7tS9NkBvwR+hI5Pt5vJ7LwXkxpqzB1gko9vks22p56fLf04CBsB1KQj9p3yr
         RehUsw2v7LbYFFqPqGNVRaUDnM5tla1nrYTME8ox0bXskMFP9RB9csfpmqIziECsrU
         fBze5+HU1svFflotAYcOQQfx2YEo2xP1r9KxCIl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.4 82/92] NFC: add NCI_UNREG flag to eliminate the race
Date:   Mon, 29 Nov 2021 19:18:51 +0100
Message-Id: <20211129181710.138349729@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 48b71a9e66c2eab60564b1b1c85f4928ed04e406 upstream.

There are two sites that calls queue_work() after the
destroy_workqueue() and lead to possible UAF.

The first site is nci_send_cmd(), which can happen after the
nci_close_device as below

nfcmrvl_nci_unregister_dev   |  nfc_genl_dev_up
  nci_close_device           |
    flush_workqueue          |
    del_timer_sync           |
  nci_unregister_device      |    nfc_get_device
    destroy_workqueue        |    nfc_dev_up
    nfc_unregister_device    |      nci_dev_up
      device_del             |        nci_open_device
                             |          __nci_request
                             |            nci_send_cmd
                             |              queue_work !!!

Another site is nci_cmd_timer, awaked by the nci_cmd_work from the
nci_send_cmd.

  ...                        |  ...
  nci_unregister_device      |  queue_work
    destroy_workqueue        |
    nfc_unregister_device    |  ...
      device_del             |  nci_cmd_work
                             |  mod_timer
                             |  ...
                             |  nci_cmd_timer
                             |    queue_work !!!

For the above two UAF, the root cause is that the nfc_dev_up can race
between the nci_unregister_device routine. Therefore, this patch
introduce NCI_UNREG flag to easily eliminate the possible race. In
addition, the mutex_lock in nci_close_device can act as a barrier.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211116152732.19238-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/nfc/nci_core.h |    1 +
 net/nfc/nci/core.c         |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -30,6 +30,7 @@ enum nci_flag {
 	NCI_UP,
 	NCI_DATA_EXCHANGE,
 	NCI_DATA_EXCHANGE_TO,
+	NCI_UNREG,
 };
 
 /* NCI device states */
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -473,6 +473,11 @@ static int nci_open_device(struct nci_de
 
 	mutex_lock(&ndev->req_lock);
 
+	if (test_bit(NCI_UNREG, &ndev->flags)) {
+		rc = -ENODEV;
+		goto done;
+	}
+
 	if (test_bit(NCI_UP, &ndev->flags)) {
 		rc = -EALREADY;
 		goto done;
@@ -536,6 +541,10 @@ done:
 static int nci_close_device(struct nci_dev *ndev)
 {
 	nci_req_cancel(ndev, ENODEV);
+
+	/* This mutex needs to be held as a barrier for
+	 * caller nci_unregister_device
+	 */
 	mutex_lock(&ndev->req_lock);
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
@@ -573,8 +582,8 @@ static int nci_close_device(struct nci_d
 	/* Flush cmd wq */
 	flush_workqueue(ndev->cmd_wq);
 
-	/* Clear flags */
-	ndev->flags = 0;
+	/* Clear flags except NCI_UNREG */
+	ndev->flags &= BIT(NCI_UNREG);
 
 	mutex_unlock(&ndev->req_lock);
 
@@ -1256,6 +1265,12 @@ void nci_unregister_device(struct nci_de
 {
 	struct nci_conn_info    *conn_info, *n;
 
+	/* This set_bit is not protected with specialized barrier,
+	 * However, it is fine because the mutex_lock(&ndev->req_lock);
+	 * in nci_close_device() will help to emit one.
+	 */
+	set_bit(NCI_UNREG, &ndev->flags);
+
 	nci_close_device(ndev);
 
 	destroy_workqueue(ndev->cmd_wq);


