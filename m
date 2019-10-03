Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0389ECA935
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404016AbfJCQjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403971AbfJCQjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F57F2086A;
        Thu,  3 Oct 2019 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120739;
        bh=s0xutKlkCj+UQ8hTmA20iOU0UaH/rpwjtQ7opHQnesI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFfpE5K+E1GR8TLW4F8c1oDF1CLT7ulQTZO8DJgMhfto7TZhq2dfSfQC5+vfxRtNS
         yrD1NcpmWI+2Tq4PYZa6btVq1Fst4R2BMweDbGyuVobj2qhADlq4zUJI2lhiD4Ucmy
         c73r3b9+O0/jwID/UsuoALgnbexUPE1g+ZlnxA0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com,
        Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 020/344] net/rds: Check laddr_check before calling it
Date:   Thu,  3 Oct 2019 17:49:45 +0200
Message-Id: <20191003154542.073432324@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

[ Upstream commit 05733434ee9ae6548723a808647248583e347cca ]

In rds_bind(), laddr_check is called without checking if it is NULL or
not.  And rs_transport should be reset if rds_add_bound() fails.

Fixes: c5c1a030a7db ("net/rds: An rds_sock is added too early to the hash table")
Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/bind.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -244,7 +244,8 @@ int rds_bind(struct socket *sock, struct
 	 */
 	if (rs->rs_transport) {
 		trans = rs->rs_transport;
-		if (trans->laddr_check(sock_net(sock->sk),
+		if (!trans->laddr_check ||
+		    trans->laddr_check(sock_net(sock->sk),
 				       binding_addr, scope_id) != 0) {
 			ret = -ENOPROTOOPT;
 			goto out;
@@ -263,6 +264,8 @@ int rds_bind(struct socket *sock, struct
 
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	ret = rds_add_bound(rs, binding_addr, &port, scope_id);
+	if (ret)
+		rs->rs_transport = NULL;
 
 out:
 	release_sock(sk);


