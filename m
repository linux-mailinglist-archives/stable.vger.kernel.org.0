Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9CE111FC2
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfLCWiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfLCWiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B345E207DD;
        Tue,  3 Dec 2019 22:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412696;
        bh=TJJCm1bg5b4jb297/34u1huue70jcy5oQ7aBzKWfPZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw2lPM7dPT2DeY+plpzIi1k9T6yajZqgAAkm/zFRndkisbsAvg54pyTT5U8MVIFdf
         c4jR+DG+K+5//cOSSNXEzIJp1FBoSWtwBgxB3cLoC5lJuWzFySyWCvN2SIyttuM8hf
         WYXMbRmomhns3CnIbsf+26mNbq4vBclR8T60Bisg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 28/46] openvswitch: remove another BUG_ON()
Date:   Tue,  3 Dec 2019 23:35:48 +0100
Message-Id: <20191203212743.041026742@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8a574f86652a4540a2433946ba826ccb87f398cc ]

If we can't build the flow del notification, we can simply delete
the flow, no need to crash the kernel. Still keep a WARN_ON to
preserve debuggability.

Note: the BUG_ON() predates the Fixes tag, but this change
can be applied only after the mentioned commit.

v1 -> v2:
 - do not leak an skb on error

Fixes: aed067783e50 ("openvswitch: Minimize ovs_flow_cmd_del critical section.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1353,7 +1353,10 @@ static int ovs_flow_cmd_del(struct sk_bu
 						     OVS_FLOW_CMD_DEL,
 						     ufid_flags);
 			rcu_read_unlock();
-			BUG_ON(err < 0);
+			if (WARN_ON_ONCE(err < 0)) {
+				kfree_skb(reply);
+				goto out_free;
+			}
 
 			ovs_notify(&dp_flow_genl_family, reply, info);
 		} else {
@@ -1361,6 +1364,7 @@ static int ovs_flow_cmd_del(struct sk_bu
 		}
 	}
 
+out_free:
 	ovs_flow_free(flow, true);
 	return 0;
 unlock:


