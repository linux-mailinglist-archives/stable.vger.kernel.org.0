Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FCA45C40F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347706AbhKXNpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350651AbhKXNli (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:41:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7B846023E;
        Wed, 24 Nov 2021 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758658;
        bh=uOAkqpECwOsIVv1EvZ3V1dlGMa02z7eAgWRPoDcvEk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIosWdLdzLLiauYxHmkX11066RnuHiwZgP5eqYjPHttC445Gzfy4rzjRAJYSTlcy4
         kApqcFitmqzyfxGlQInAzfLbN6ndjVM7sxZbcD9T1OP0DAIfBjkZ9D/7XsfJCMDMjn
         n7DOkVhCVP+Tu+TNdqmd5OnTRzdKY3J5WF3Ys72g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/154] NFC: add NCI_UNREG flag to eliminate the race
Date:   Wed, 24 Nov 2021 12:58:26 +0100
Message-Id: <20211124115705.844427181@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 48b71a9e66c2eab60564b1b1c85f4928ed04e406 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nfc/nci_core.h |  1 +
 net/nfc/nci/core.c         | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 33979017b7824..004e49f748419 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -30,6 +30,7 @@ enum nci_flag {
 	NCI_UP,
 	NCI_DATA_EXCHANGE,
 	NCI_DATA_EXCHANGE_TO,
+	NCI_UNREG,
 };
 
 /* NCI device states */
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 4d3ab0f44c9f4..e38719e2ee582 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -473,6 +473,11 @@ static int nci_open_device(struct nci_dev *ndev)
 
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
@@ -573,8 +582,8 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	del_timer_sync(&ndev->cmd_timer);
 
-	/* Clear flags */
-	ndev->flags = 0;
+	/* Clear flags except NCI_UNREG */
+	ndev->flags &= BIT(NCI_UNREG);
 
 	mutex_unlock(&ndev->req_lock);
 
@@ -1259,6 +1268,12 @@ void nci_unregister_device(struct nci_dev *ndev)
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
-- 
2.33.0



