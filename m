Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6164728F1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244194AbhLMKQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243788AbhLMKOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B07C08ED78;
        Mon, 13 Dec 2021 01:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4229B80E0C;
        Mon, 13 Dec 2021 09:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7661C34600;
        Mon, 13 Dec 2021 09:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389301;
        bh=xyuxhrqRtt6uGmkMlP/GJ4qCXYEpTPAKCmXMEUmbOJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDqL8rsvZsADbMroSaq5AFuzbs+mpEsUig6WXifRFs/1I3SlF/sat7r2Si8mFb2YA
         NEdUMsy0qOBKOD4MUTvoGih3MAwqPzplqzrUB/305QnCMwiT3/H22KHalWSneCol7Z
         ixY6XxS2r49A1ISjoy+k23K2J+plw84pgHfd9kR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 051/171] devlink: fix netns refcount leak in devlink_nl_cmd_reload()
Date:   Mon, 13 Dec 2021 10:29:26 +0100
Message-Id: <20211213092946.805975522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 4dbb0dad8e63fcd0b5a117c2861d2abe7ff5f186 upstream.

While preparing my patch series adding netns refcount tracking,
I spotted bugs in devlink_nl_cmd_reload()

Some error paths forgot to release a refcount on a netns.

To fix this, we can reduce the scope of get_net()/put_net()
section around the call to devlink_reload().

Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Moshe Shemesh <moshe@mellanox.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20211205192822.1741045-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4031,14 +4031,6 @@ static int devlink_nl_cmd_reload(struct
 		return err;
 	}
 
-	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
-	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
-	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
-		dest_net = devlink_netns_get(skb, info);
-		if (IS_ERR(dest_net))
-			return PTR_ERR(dest_net);
-	}
-
 	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
 		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
 	else
@@ -4081,6 +4073,14 @@ static int devlink_nl_cmd_reload(struct
 			return -EINVAL;
 		}
 	}
+	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
+		dest_net = devlink_netns_get(skb, info);
+		if (IS_ERR(dest_net))
+			return PTR_ERR(dest_net);
+	}
+
 	err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
 
 	if (dest_net)


