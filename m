Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D37111EE8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfLCWt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbfLCWt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F09E2084B;
        Tue,  3 Dec 2019 22:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413397;
        bh=t2V8Sq0VvaON+weVpHvFiteFpdcQUZGqb6wrVV0MoQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErB6VvSdtySIrWlpHqucCeEG/mGUFDjvFOyD+uUGEmtGsjcZhdl2mct1Qv/p9FTjp
         Iem+2T/3PTmzFHXhR1WZa9H3zgE0Ux4g34HdMhM/i6/QkZxo2O4UgGmvIRwqu/9YvH
         GeEkwwKP+4JbuD1xnkH7No13geBITxTlsu1Is6vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atul Gupta <atul.gupta@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/321] crypto/chelsio/chtls: listen fails with multiadapt
Date:   Tue,  3 Dec 2019 23:32:58 +0100
Message-Id: <20191203223432.978270676@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gupta <atul.gupta@chelsio.com>

[ Upstream commit 6422ccc5fbefbd219f3fab133f698e58f5aa44eb ]

listen fails when more than one tls capable device is
registered. tls_hw_hash is called for each dev which loops
again for each cdev_list causing listen failure. Hence
call chtls_listen_start/stop for specific device than loop over all
devices.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chtls/chtls.h      |  5 +++
 drivers/crypto/chelsio/chtls/chtls_main.c | 50 ++++++++++++++---------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 7725b6ee14efb..fcb6747ed29ea 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -153,6 +153,11 @@ struct chtls_dev {
 	unsigned int cdev_state;
 };
 
+struct chtls_listen {
+	struct chtls_dev *cdev;
+	struct sock *sk;
+};
+
 struct chtls_hws {
 	struct sk_buff_head sk_recv_queue;
 	u8 txqid;
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index f59b044ebd255..2bf084afe9b58 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -55,24 +55,19 @@ static void unregister_listen_notifier(struct notifier_block *nb)
 static int listen_notify_handler(struct notifier_block *this,
 				 unsigned long event, void *data)
 {
-	struct chtls_dev *cdev;
-	struct sock *sk;
-	int ret;
+	struct chtls_listen *clisten;
+	int ret = NOTIFY_DONE;
 
-	sk = data;
-	ret =  NOTIFY_DONE;
+	clisten = (struct chtls_listen *)data;
 
 	switch (event) {
 	case CHTLS_LISTEN_START:
+		ret = chtls_listen_start(clisten->cdev, clisten->sk);
+		kfree(clisten);
+		break;
 	case CHTLS_LISTEN_STOP:
-		mutex_lock(&cdev_list_lock);
-		list_for_each_entry(cdev, &cdev_list, list) {
-			if (event == CHTLS_LISTEN_START)
-				ret = chtls_listen_start(cdev, sk);
-			else
-				chtls_listen_stop(cdev, sk);
-		}
-		mutex_unlock(&cdev_list_lock);
+		chtls_listen_stop(clisten->cdev, clisten->sk);
+		kfree(clisten);
 		break;
 	}
 	return ret;
@@ -90,8 +85,9 @@ static int listen_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-static int chtls_start_listen(struct sock *sk)
+static int chtls_start_listen(struct chtls_dev *cdev, struct sock *sk)
 {
+	struct chtls_listen *clisten;
 	int err;
 
 	if (sk->sk_protocol != IPPROTO_TCP)
@@ -102,21 +98,33 @@ static int chtls_start_listen(struct sock *sk)
 		return -EADDRNOTAVAIL;
 
 	sk->sk_backlog_rcv = listen_backlog_rcv;
+	clisten = kmalloc(sizeof(*clisten), GFP_KERNEL);
+	if (!clisten)
+		return -ENOMEM;
+	clisten->cdev = cdev;
+	clisten->sk = sk;
 	mutex_lock(&notify_mutex);
 	err = raw_notifier_call_chain(&listen_notify_list,
-				      CHTLS_LISTEN_START, sk);
+				      CHTLS_LISTEN_START, clisten);
 	mutex_unlock(&notify_mutex);
 	return err;
 }
 
-static void chtls_stop_listen(struct sock *sk)
+static void chtls_stop_listen(struct chtls_dev *cdev, struct sock *sk)
 {
+	struct chtls_listen *clisten;
+
 	if (sk->sk_protocol != IPPROTO_TCP)
 		return;
 
+	clisten = kmalloc(sizeof(*clisten), GFP_KERNEL);
+	if (!clisten)
+		return;
+	clisten->cdev = cdev;
+	clisten->sk = sk;
 	mutex_lock(&notify_mutex);
 	raw_notifier_call_chain(&listen_notify_list,
-				CHTLS_LISTEN_STOP, sk);
+				CHTLS_LISTEN_STOP, clisten);
 	mutex_unlock(&notify_mutex);
 }
 
@@ -138,15 +146,19 @@ static int chtls_inline_feature(struct tls_device *dev)
 
 static int chtls_create_hash(struct tls_device *dev, struct sock *sk)
 {
+	struct chtls_dev *cdev = to_chtls_dev(dev);
+
 	if (sk->sk_state == TCP_LISTEN)
-		return chtls_start_listen(sk);
+		return chtls_start_listen(cdev, sk);
 	return 0;
 }
 
 static void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
 {
+	struct chtls_dev *cdev = to_chtls_dev(dev);
+
 	if (sk->sk_state == TCP_LISTEN)
-		chtls_stop_listen(sk);
+		chtls_stop_listen(cdev, sk);
 }
 
 static void chtls_register_dev(struct chtls_dev *cdev)
-- 
2.20.1



