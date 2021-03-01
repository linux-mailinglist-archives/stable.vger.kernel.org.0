Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2475B328573
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhCAQxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235688AbhCAQsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:48:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E06E64EE2;
        Mon,  1 Mar 2021 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616332;
        bh=5f4su6Cer228tSfMSbxbYPu7BsCU96a5nErvgiBQkwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLRaCBbIw5PVt8/6gAIcFaktXoZkZsXuLimlEJbMsMbpfdvVVaGE+Y5IglYDWvg2e
         jMlafkMr3bR8vE9Fd04PH5Rk2+5+9Hp4jYFA2OkuXVTNLg15l1zz7K5bDDUnvTs8zB
         iJtlKi2NAiysX7gxe5sbabihA5CsT6rRTkVuEBTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 114/176] ocfs2: fix a use after free on error
Date:   Mon,  1 Mar 2021 17:13:07 +0100
Message-Id: <20210301161026.639828610@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c57d117f2b2f2a19b570c36f2819ef8d8210af20 ]

The error handling in this function frees "reg" but it is still on the
"o2hb_all_regions" list so it will lead to a use after freew.  Joseph Qi
points out that we need to clear the bit in the "o2hb_region_bitmap" as
well

Link: https://lkml.kernel.org/r/YBk4M6HUG8jB/jc7@mwanda
Fixes: 1cf257f51191 ("ocfs2: fix memory leak")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index d0206042d068b..241dd3bb30e4f 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2154,7 +2154,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 			o2hb_nego_timeout_handler,
 			reg, NULL, &reg->hr_handler_list);
 	if (ret)
-		goto free;
+		goto remove_item;
 
 	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
 			sizeof(struct o2hb_nego_msg),
@@ -2173,6 +2173,12 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 unregister_handler:
 	o2net_unregister_handler_list(&reg->hr_handler_list);
+remove_item:
+	spin_lock(&o2hb_live_lock);
+	list_del(&reg->hr_all_item);
+	if (o2hb_global_heartbeat_active())
+		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
+	spin_unlock(&o2hb_live_lock);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);
-- 
2.27.0



