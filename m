Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977F015661A
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgBHSbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34642 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727946AbgBHS3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:49 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003ja-RQ; Sat, 08 Feb 2020 18:29:43 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CWC-DO; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>
Date:   Sat, 08 Feb 2020 18:21:09 +0000
Message-ID: <lsq.1581185941.769130492@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 130/148] openvswitch: drop unneeded BUG_ON() in
 ovs_flow_cmd_build_info()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 8ffeb03fbba3b599690b361467bfd2373e8c450f upstream.

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/openvswitch/datapath.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -788,7 +788,10 @@ static struct sk_buff *ovs_flow_cmd_buil
 	retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
 					info->snd_portid, info->snd_seq, 0,
 					cmd);
-	BUG_ON(retval < 0);
+	if (WARN_ON_ONCE(retval < 0)) {
+		kfree_skb(skb);
+		skb = ERR_PTR(retval);
+	}
 	return skb;
 }
 

