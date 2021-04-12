Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A0835B88F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbhDLCXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhDLCXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E1361209;
        Mon, 12 Apr 2021 02:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194195;
        bh=r+dmmTQfh3+8JnnGkVLkzh4h4YTOCJDgPCzzenQ+O1A=;
        h=From:To:Cc:Subject:Date:From;
        b=eB1V1e7ccnsRn4YVPy01wTB87nTA33iC+ro291jivgvk+1h/rxeJEveK71VvHCpeB
         4ybkUXcg3OsGuhkHZTlwsU0YBQCyq03SsgYtS3rpYEu2i7NLkO/ES4G+Orj5yyQX98
         x0a8Ns3GJzIti+8o6sHm7gPuzSXUeud8wW3Ilu8pN7dtFqPH4dPfvMYtcJ86uRSq6t
         QuV9/n5mo6ApSDz2Ir/mIKjxfSOMnbiKnwpGMpquUk163zMGl0ULkw1uZNs60VfYn0
         HwXDNV95i72byKj5YLCi0BAPNxgx7a6RCB2lvWV9PkK5juAh/JmcyK/ru4epJtCvXg
         mf8z868Z9X9BA==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, fido_max@inbox.ru
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "net: dsa: Fix type was not set for devlink port" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:14 -0400
Message-Id: <20210412022314.284033-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From fb6ec87f7229b92baa81b35cbc76f2626d5bfadb Mon Sep 17 00:00:00 2001
From: Maxim Kochetkov <fido_max@inbox.ru>
Date: Mon, 29 Mar 2021 18:30:16 +0300
Subject: [PATCH] net: dsa: Fix type was not set for devlink port

If PHY is not available on DSA port (described at devicetree but absent or
failed to detect) then kernel prints warning after 3700 secs:

[ 3707.948771] ------------[ cut here ]------------
[ 3707.948784] Type was not set for devlink port.
[ 3707.948894] WARNING: CPU: 1 PID: 17 at net/core/devlink.c:8097 0xc083f9d8

We should unregister the devlink port as a user port and
re-register it as an unused port before executing "continue" in case of
dsa_port_setup error.

Fixes: 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/dsa/dsa2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d142eb2b288b..3c3e56a1f34d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -795,8 +795,14 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
-		if (err)
+		if (err) {
+			dsa_port_devlink_teardown(dp);
+			dp->type = DSA_PORT_TYPE_UNUSED;
+			err = dsa_port_devlink_setup(dp);
+			if (err)
+				goto teardown;
 			continue;
+		}
 	}
 
 	return 0;
-- 
2.30.2




