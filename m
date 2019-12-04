Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DAD113196
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfLDSAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbfLDSAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:00:50 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE4D20675;
        Wed,  4 Dec 2019 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482450;
        bh=G+oSkkHo33aseX2yDHd1/cqRjidMk2lLRRLZuq3yOes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zZtDUta/gdm1GG4NJ5oQNr5zD803DilqtxVAPn+dgRoTE4PqTfKE2XyWSCqKPrsa
         U56Wcm8wL7qt0itxAgCWw+1SwqSQm5A1o2eRME8PF466db+z8ZG5mHUeutvVPkZB+w
         aWxoq6XORRLQ77lE+mDRYBUriqTDl4Afd3Qi57ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 86/92] openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
Date:   Wed,  4 Dec 2019 18:50:26 +0100
Message-Id: <20191204174335.355653224@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8ffeb03fbba3b599690b361467bfd2373e8c450f ]

All the callers of ovs_flow_cmd_build_info() already deal with
error return code correctly, so we can handle the error condition
in a more gracefull way. Still dump a warning to preserve
debuggability.

v1 -> v2:
 - clarify the commit message
 - clean the skb and report the error (DaveM)

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -904,7 +904,10 @@ static struct sk_buff *ovs_flow_cmd_buil
 	retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
 					info->snd_portid, info->snd_seq, 0,
 					cmd, ufid_flags);
-	BUG_ON(retval < 0);
+	if (WARN_ON_ONCE(retval < 0)) {
+		kfree_skb(skb);
+		skb = ERR_PTR(retval);
+	}
 	return skb;
 }
 


