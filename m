Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D4015C693
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBMQBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbgBMPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:37 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA06246DA;
        Thu, 13 Feb 2020 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607476;
        bh=37/ll+Q8F05WZcAJOUYCDjnU8UFeyuVajRI2A0XgZP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDvUmiAqMA2zxrvzhLddQZl5MYzjVNfFgqlrr7+W8EgJWCnaSqn9MDNzEPezFoC0d
         5q4fxMDz9AjRhntL6qoUVQPD6ZmysEGjWWKGA9Xo6apCUOmqHs46F0MldEnt4FZg+m
         OdEW5Jt6bWmVXvy4u0VuBNr4HMknvd+e4+2omKSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 008/173] l2tp: Allow duplicate session creation with UDP
Date:   Thu, 13 Feb 2020 07:18:31 -0800
Message-Id: <20200213151934.510224161@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>

[ Upstream commit 0d0d9a388a858e271bb70e71e99e7fe2a6fd6f64 ]

In the past it was possible to create multiple L2TPv3 sessions with the
same session id as long as the sessions belonged to different tunnels.
The resulting sessions had issues when used with IP encapsulated tunnels,
but worked fine with UDP encapsulated ones. Some applications began to
rely on this behaviour to avoid having to negotiate unique session ids.

Some time ago a change was made to require session ids to be unique across
all tunnels, breaking the applications making use of this "feature".

This change relaxes the duplicate session id check to allow duplicates
if both of the colliding sessions belong to UDP encapsulated tunnels.

Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
Signed-off-by: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Acked-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -358,8 +358,13 @@ static int l2tp_session_add_to_tunnel(st
 
 		spin_lock_bh(&pn->l2tp_session_hlist_lock);
 
+		/* IP encap expects session IDs to be globally unique, while
+		 * UDP encap doesn't.
+		 */
 		hlist_for_each_entry(session_walk, g_head, global_hlist)
-			if (session_walk->session_id == session->session_id) {
+			if (session_walk->session_id == session->session_id &&
+			    (session_walk->tunnel->encap == L2TP_ENCAPTYPE_IP ||
+			     tunnel->encap == L2TP_ENCAPTYPE_IP)) {
 				err = -EEXIST;
 				goto err_tlock_pnlock;
 			}


