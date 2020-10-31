Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09B62A1650
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgJaLoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgJaLoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE9620731;
        Sat, 31 Oct 2020 11:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144658;
        bh=BZaia0VGdkH2dsmtDYK+qDMiJcBp4k+u/wtEFlDVaGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJQnAGonZsXlJMRXarEX3z6hb6VsZS9ksbEDhPldk9vwXMXSQoU+AdOdKhjtWjCqq
         V7pqTe9Sb4TyEZaCp/XNDeiRZb541G3vZauPYdWwG6OFrVh+dMDGb4H4BfG7XE5kfk
         EfaDIE3+pYnSdpFcxOg0REue/H40nkAwCClzHTiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 32/74] chelsio/chtls: fix deadlock issue
Date:   Sat, 31 Oct 2020 12:36:14 +0100
Message-Id: <20201031113501.582935104@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 28e9dcd9172028263c8225c15c4e329e08475e89 ]

In chtls_pass_establish() we hold child socket lock using bh_lock_sock
and we are again trying bh_lock_sock in add_to_reap_list, causing deadlock.
Remove bh_lock_sock in add_to_reap_list() as lock is already held.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Link: https://lore.kernel.org/r/20201025193538.31112-1-vinay.yadav@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1514,7 +1514,6 @@ static void add_to_reap_list(struct sock
 	struct chtls_sock *csk = sk->sk_user_data;
 
 	local_bh_disable();
-	bh_lock_sock(sk);
 	release_tcp_port(sk); /* release the port immediately */
 
 	spin_lock(&reap_list_lock);
@@ -1523,7 +1522,6 @@ static void add_to_reap_list(struct sock
 	if (!csk->passive_reap_next)
 		schedule_work(&reap_task);
 	spin_unlock(&reap_list_lock);
-	bh_unlock_sock(sk);
 	local_bh_enable();
 }
 


