Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AE4726CD
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhLMJyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbhLMJwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293D7C08EADC;
        Mon, 13 Dec 2021 01:44:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 759ABCE0E92;
        Mon, 13 Dec 2021 09:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CCEC00446;
        Mon, 13 Dec 2021 09:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388684;
        bh=IgI7V+rJHEBCgtv5IffGcg8HDrt4Y5DOlbM8kwCl3T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8jRyXWU0bvYTeKuCrkC/CuSmrctqtEBIJq7tAs2TI/u3iB7/ynP0gkStncdoc7Ab
         5PUc60D263bgmuW8OiWJlBoRRSU0ZE3EN8cMYZLzMp7B5495bqiOzThWC9NGi2dJ1G
         Ypjr4MF6WUV5qcjvKb5o8azmIL4U6V1vqzLKR36w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 62/88] net/qla3xxx: fix an error code in ql_adapter_up()
Date:   Mon, 13 Dec 2021 10:30:32 +0100
Message-Id: <20211213092935.401565045@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d17b9737c2bc09b4ac6caf469826e5a7ce3ffab7 upstream.

The ql_wait_for_drvr_lock() fails and returns false, then this
function should return an error code instead of returning success.

The other problem is that the success path prints an error message
netdev_err(ndev, "Releasing driver lock\n");  Delete that and
re-order the code a little to make it more clear.

Fixes: 5a4faa873782 ("[PATCH] qla3xxx NIC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211207082416.GA16110@kili
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3495,20 +3495,19 @@ static int ql_adapter_up(struct ql3_adap
 
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 
-	err = ql_wait_for_drvr_lock(qdev);
-	if (err) {
-		err = ql_adapter_initialize(qdev);
-		if (err) {
-			netdev_err(ndev, "Unable to initialize adapter\n");
-			goto err_init;
-		}
-		netdev_err(ndev, "Releasing driver lock\n");
-		ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
-	} else {
+	if (!ql_wait_for_drvr_lock(qdev)) {
 		netdev_err(ndev, "Could not acquire driver lock\n");
+		err = -ENODEV;
 		goto err_lock;
 	}
 
+	err = ql_adapter_initialize(qdev);
+	if (err) {
+		netdev_err(ndev, "Unable to initialize adapter\n");
+		goto err_init;
+	}
+	ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
+
 	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 
 	set_bit(QL_ADAPTER_UP, &qdev->flags);


