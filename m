Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E776045134F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbhKOTuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245578AbhKOTUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B74C663562;
        Mon, 15 Nov 2021 18:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001431;
        bh=avAAGN5EkykCH99Df14J6Rgv0P1Mu556HWaJrlB2Xhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zq015rekOlUO3OSLnfLnrtGFgAxkv0y+xa6nQCL0PyJhSWg3npVKrV41FhZpjCLJi
         7cKI9XsEFCyewoN3GF3J+Vcz+Q2BM5Valah4LK/ndBuIFn8BMHyKm3QfZcgzU0Rqty
         VhgH/8N3f/IhM5MxTYnQi4KVEJSMSfBsY4M0SSeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/917] Bluetooth: call sock_hold earlier in sco_conn_del
Date:   Mon, 15 Nov 2021 17:54:43 +0100
Message-Id: <20211115165435.167290820@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit f4712fa993f688d0a48e0c28728fcdeb88c1ea58 ]

In sco_conn_del, conn->sk is read while holding on to the
sco_conn.lock to avoid races with a socket that could be released
concurrently.

However, in between unlocking sco_conn.lock and calling sock_hold,
it's possible for the socket to be freed, which would cause a
use-after-free write when sock_hold is finally called.

To fix this, the reference count of the socket should be increased
while the sco_conn.lock is still held.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index b62c91c627e2c..4a057f99b60aa 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -187,10 +187,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 	/* Kill socket */
 	sco_conn_lock(conn);
 	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
 	sco_conn_unlock(conn);
 
 	if (sk) {
-		sock_hold(sk);
 		lock_sock(sk);
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
-- 
2.33.0



