Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D7B498A9A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345450AbiAXTF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:05:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33282 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbiAXTC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:02:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8354A6090C;
        Mon, 24 Jan 2022 19:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C7FC340E5;
        Mon, 24 Jan 2022 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050976;
        bh=dxUf+U6Z7K+kw5Lnyb3mdDP9kwZPt1I3PrYQHepooz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZFvdtilGcnlTX5X4fqgZ0VUXS1J1aBasEYQkKPDGUL9DtYQCyToMmSucrFqOhjIV
         7jPNuVcfxK6qnzL9ctQoNGzyncwd6S4a26UcVT+ik4oOjv5+e4uPR6zqowfqwK2yif
         DUg99cbmms0UzT4iDToFn617PcQ0yU67RxAVunbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 015/186] Bluetooth: fix init and cleanup of sco_conn.timeout_work
Date:   Mon, 24 Jan 2022 19:41:30 +0100
Message-Id: <20220124183937.598856978@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit 49d8a5606428ca0962d09050a5af81461ff90fbb upstream.

Before freeing struct sco_conn, all delayed timeout work should be
cancelled. Otherwise, sco_sock_timeout could potentially use the
sco_conn after it has been freed.

Additionally, sco_conn.timeout_work should be initialized when the
connection is allocated, not when the channel is added. This is
because an sco_conn can create channels with multiple sockets over its
lifetime, which happens if sockets are released but the connection
isn't deleted.

Fixes: ba316be1b6a0 ("Bluetooth: schedule SCO timeouts with delayed_work")
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[OP: adjusted context for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -133,6 +133,7 @@ static struct sco_conn *sco_conn_add(str
 		return NULL;
 
 	spin_lock_init(&conn->lock);
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
 
 	hcon->sco_data = conn;
 	conn->hcon = hcon;
@@ -196,11 +197,11 @@ static void sco_conn_del(struct hci_conn
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
 		sock_put(sk);
-
-		/* Ensure no more work items will run before freeing conn. */
-		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
+	/* Ensure no more work items will run before freeing conn. */
+	cancel_delayed_work_sync(&conn->timeout_work);
+
 	hcon->sco_data = NULL;
 	kfree(conn);
 }
@@ -213,8 +214,6 @@ static void __sco_chan_add(struct sco_co
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
-	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
-
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }


