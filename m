Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66BF450B6B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbhKORYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:24:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237434AbhKORV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:21:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D394D63276;
        Mon, 15 Nov 2021 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996552;
        bh=Pvhv/B3YxwT9Sn822dIfQ2iAzGukX1ZVgpjMVqL7SCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8f/funAJa1SObdLbjduroHozYtBomJMFX+PsqSORZxPLK/uQLj1GXi1mFulbOwz5
         qpnx3CMOeZBJR/dsvRdg82xf81oCfN1AKQaAtLVkrGJiSWtYwDv1AjbCICHkiVtucz
         5CSukPQMm5dFn6sPlC9JnE9FvEEoVi/586U6GfKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/355] Bluetooth: fix init and cleanup of sco_conn.timeout_work
Date:   Mon, 15 Nov 2021 18:01:46 +0100
Message-Id: <20211115165319.667399815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 49d8a5606428ca0962d09050a5af81461ff90fbb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index cc5a1d2545679..2c616c1c62958 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -133,6 +133,7 @@ static struct sco_conn *sco_conn_add(struct hci_conn *hcon)
 		return NULL;
 
 	spin_lock_init(&conn->lock);
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
 
 	hcon->sco_data = conn;
 	conn->hcon = hcon;
@@ -196,11 +197,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
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
@@ -213,8 +214,6 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
-	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
-
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
-- 
2.33.0



