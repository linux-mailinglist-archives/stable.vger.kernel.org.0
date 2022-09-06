Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12DF5AEA3F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiIFNlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiIFNkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:40:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F057DF63;
        Tue,  6 Sep 2022 06:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 441BCB818C2;
        Tue,  6 Sep 2022 13:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896BDC433D6;
        Tue,  6 Sep 2022 13:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471414;
        bh=NWUzBANqXW9GVAHrKIuVNQwpQgRn9It+MIN89V6w+x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf9xSod86gXyJHw3k0jXrAURz8Rpt3mVKVmUHDwG4BteaQMtAsnyj+bQVR//3uoJc
         nlqWzISZ55J5zNAXyklF1va3iPJ1T/V32lOTpoAZJfVO5fzoXUY0WQUpgUpoVnwXCp
         H45y4u/fzF5fIxS0VW3/fCFnzBkvgVUEylXSyMe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Conole <aconole@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/107] openvswitch: fix memory leak at failed datapath creation
Date:   Tue,  6 Sep 2022 15:30:00 +0200
Message-Id: <20220906132822.567603670@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>

[ Upstream commit a87406f4adee9c53b311d8a1ba2849c69e29a6d0 ]

ovs_dp_cmd_new()->ovs_dp_change()->ovs_dp_set_upcall_portids()
allocates array via kmalloc.
If for some reason new_vport() fails during ovs_dp_cmd_new()
dp->upcall_portids must be freed.
Add missing kfree.

Kmemleak example:
unreferenced object 0xffff88800c382500 (size 64):
  comm "dump_state", pid 323, jiffies 4294955418 (age 104.347s)
  hex dump (first 32 bytes):
    5e c2 79 e4 1f 7a 38 c7 09 21 38 0c 80 88 ff ff  ^.y..z8..!8.....
    03 00 00 00 0a 00 00 00 14 00 00 00 28 00 00 00  ............(...
  backtrace:
    [<0000000071bebc9f>] ovs_dp_set_upcall_portids+0x38/0xa0
    [<000000000187d8bd>] ovs_dp_change+0x63/0xe0
    [<000000002397e446>] ovs_dp_cmd_new+0x1f0/0x380
    [<00000000aa06f36e>] genl_family_rcv_msg_doit+0xea/0x150
    [<000000008f583bc4>] genl_rcv_msg+0xdc/0x1e0
    [<00000000fa10e377>] netlink_rcv_skb+0x50/0x100
    [<000000004959cece>] genl_rcv+0x24/0x40
    [<000000004699ac7f>] netlink_unicast+0x23e/0x360
    [<00000000c153573e>] netlink_sendmsg+0x24e/0x4b0
    [<000000006f4aa380>] sock_sendmsg+0x62/0x70
    [<00000000d0068654>] ____sys_sendmsg+0x230/0x270
    [<0000000012dacf7d>] ___sys_sendmsg+0x88/0xd0
    [<0000000011776020>] __sys_sendmsg+0x59/0xa0
    [<000000002e8f2dc1>] do_syscall_64+0x3b/0x90
    [<000000003243e7cb>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: b83d23a2a38b ("openvswitch: Introduce per-cpu upcall dispatch")
Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Link: https://lore.kernel.org/r/20220825020326.664073-1-andrey.zhadchenko@virtuozzo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 67ad08320886b..5e2c83cb7b129 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1801,7 +1801,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
-		goto err_unlock_and_destroy_meters;
+		goto err_destroy_portids;
 	}
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
@@ -1816,6 +1816,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_datapath_genl_family, reply, info);
 	return 0;
 
+err_destroy_portids:
+	kfree(rcu_dereference_raw(dp->upcall_portids));
 err_unlock_and_destroy_meters:
 	ovs_unlock();
 	ovs_meters_exit(dp);
-- 
2.35.1



