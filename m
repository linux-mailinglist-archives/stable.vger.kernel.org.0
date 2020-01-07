Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1419B1332F9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgAGVIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgAGVI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEDB2077B;
        Tue,  7 Jan 2020 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431308;
        bh=y4u0GGqzvmPD1hulz4bMt4c5qg6Q6An5RCpTRMXvP6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPcZxWHWCqB7/yLacZllyWghk1fz81o3ZXaHDRcu+FGn/NPdLAwFVyG0Z8MZRoCeV
         S1T8k68KNKU/TVhzJJfaOlznyxMOsiKs8qbYbdfKg3nxlLSXUElMSkiQ90ZKf0KxCj
         XVQWf2sxMTgsN95e7oTANOHMPOlTrwzSRzortK8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.19 087/115] Bluetooth: delete a stray unlock
Date:   Tue,  7 Jan 2020 21:54:57 +0100
Message-Id: <20200107205306.387840643@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit df66499a1fab340c167250a5743931dc50d5f0fa upstream.

We used to take a lock in amp_physical_cfm() but then we moved it to
the caller function.  Unfortunately the unlock on this error path was
overlooked so it leads to a double unlock.

Fixes: a514b17fab51 ("Bluetooth: Refactor locking in amp_physical_cfm")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4918,10 +4918,8 @@ void __l2cap_physical_cfm(struct l2cap_c
 	BT_DBG("chan %p, result %d, local_amp_id %d, remote_amp_id %d",
 	       chan, result, local_amp_id, remote_amp_id);
 
-	if (chan->state == BT_DISCONN || chan->state == BT_CLOSED) {
-		l2cap_chan_unlock(chan);
+	if (chan->state == BT_DISCONN || chan->state == BT_CLOSED)
 		return;
-	}
 
 	if (chan->state != BT_CONNECTED) {
 		l2cap_do_create(chan, result, local_amp_id, remote_amp_id);


