Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F7A1D82FA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgERSBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731150AbgERSBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB65207C4;
        Mon, 18 May 2020 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824859;
        bh=WCW8J/ij3ACC0sBMzpTf7NAW+QQ1DhaJiJ/NyaSI100=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyfX0a7QdDv9O/yTbFDU3SoAcCi75xDazQGFQz8auAYdJ2Bj3FQRzfwxVuoraJlhi
         tdqUDn5rQ+c1YWR7m/8kOioiE2LUfWzmv0UHFSWWprCt0osurFeSs9FfIowMMhIS2z
         1Wovy1EKiGz0rdT1eUFVRc16aXKvRif45zm3qju4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 031/194] mptcp: set correct vfs info for subflows
Date:   Mon, 18 May 2020 19:35:21 +0200
Message-Id: <20200518173534.141303676@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 7d14b0d2b9b317cfc14161143e2006b95a5da9b1 ]

When a subflow is created via mptcp_subflow_create_socket(),
a new 'struct socket' is allocated, with a new i_ino value.

When inspecting TCP sockets via the procfs and or the diag
interface, the above ones are not related to the process owning
the MPTCP master socket, even if they are a logical part of it
('ss -p' shows an empty process field)

Additionally, subflows created by the path manager get
the uid/gid from the running workqueue.

Subflows are part of the owning MPTCP master socket, let's
adjust the vfs info to reflect this.

After this patch, 'ss' correctly displays subflows as belonging
to the msk socket creator.

Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -633,6 +633,16 @@ int mptcp_subflow_create_socket(struct s
 	if (err)
 		return err;
 
+	/* the newly created socket really belongs to the owning MPTCP master
+	 * socket, even if for additional subflows the allocation is performed
+	 * by a kernel workqueue. Adjust inode references, so that the
+	 * procfs/diag interaces really show this one belonging to the correct
+	 * user.
+	 */
+	SOCK_INODE(sf)->i_ino = SOCK_INODE(sk->sk_socket)->i_ino;
+	SOCK_INODE(sf)->i_uid = SOCK_INODE(sk->sk_socket)->i_uid;
+	SOCK_INODE(sf)->i_gid = SOCK_INODE(sk->sk_socket)->i_gid;
+
 	subflow = mptcp_subflow_ctx(sf->sk);
 	pr_debug("subflow=%p", subflow);
 


