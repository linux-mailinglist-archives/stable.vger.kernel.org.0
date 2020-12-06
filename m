Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17DE2D03E4
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgLFLlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgLFLlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:41:19 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Udai Sharma <udai.sharma@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 26/32] chelsio/chtls: fix panic during unload reload chtls
Date:   Sun,  6 Dec 2020 12:17:26 +0100
Message-Id: <20201206111557.024869134@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit e3d5e971d2f83d8ddd4b91a50cea4517fb488383 ]

there is kernel panic in inet_twsk_free() while chtls
module unload when socket is in TIME_WAIT state because
sk_prot_creator was not preserved on connection socket.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Udai Sharma <udai.sharma@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Link: https://lore.kernel.org/r/20201125214913.16938-1-vinay.yadav@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1079,6 +1079,7 @@ static struct sock *chtls_recv_sock(stru
 
 	oreq->ts_recent = PASS_OPEN_TID_G(ntohl(req->tos_stid));
 	sk_setup_caps(newsk, dst);
+	newsk->sk_prot_creator = lsk->sk_prot_creator;
 	csk->sk = newsk;
 	csk->passive_reap_next = oreq;
 	csk->tx_chan = cxgb4_port_chan(ndev);


