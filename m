Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3810A111E96
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfLCXCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:02:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbfLCWyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7AD820803;
        Tue,  3 Dec 2019 22:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413686;
        bh=ePJ2pkZNK2a4mQjfJXGV5Pv+SMUz7DMtBlOvjCi1n7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8CtXLbuNxrHiVOZuLAfXfTlblfxxOBurNXC9cfOLHdCWtt+NpcKIzs5G8rrZkZ/y
         0y1Je7h8MgEEvU6c2YDWoSvICr7CwoFjn+V/ZhasQRKLZ3Y4OE22qQMwj8khdQOV6p
         hJT/5hjRQRAzo7jmqxDb9qIvk0YQ3yrxyKX6z1RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/321] net/smc: prevent races between smc_lgr_terminate() and smc_conn_free()
Date:   Tue,  3 Dec 2019 23:34:50 +0100
Message-Id: <20191203223438.769639679@linuxfoundation.org>
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

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 77f838ace755d2f466536c44dac6c856f62cd901 ]

To prevent races between smc_lgr_terminate() and smc_conn_free() add an
extra check of the lgr field before accessing it, and cancel a delayed
free_work when a new smc connection is created.
This fixes the problem that free_work cleared the lgr variable but
smc_lgr_terminate() or smc_conn_free() still access it in parallel.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 18daebcef1813..2c9baf8bf1189 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -128,6 +128,8 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
 
+	if (!lgr)
+		return;
 	write_lock_bh(&lgr->conns_lock);
 	if (conn->alert_token_local) {
 		__smc_lgr_unregister_conn(conn);
@@ -612,6 +614,8 @@ int smc_conn_create(struct smc_sock *smc, bool is_smcd, int srv_first_contact,
 			local_contact = SMC_REUSE_CONTACT;
 			conn->lgr = lgr;
 			smc_lgr_register_conn(conn); /* add smc conn to lgr */
+			if (delayed_work_pending(&lgr->free_work))
+				cancel_delayed_work(&lgr->free_work);
 			write_unlock_bh(&lgr->conns_lock);
 			break;
 		}
-- 
2.20.1



