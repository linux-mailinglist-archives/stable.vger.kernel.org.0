Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062DC63537E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbiKWIyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiKWIya (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:54:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B1EEA106
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5FB8B81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEC6C433C1;
        Wed, 23 Nov 2022 08:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193667;
        bh=dkJKQOeejYvmxjXbcWytvc4UbwAgrHIlFHqWkZsJpm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAtthQ8MxsjSNf4/EsS5cFweNJrhs9Osu7pMcdqr9K5xPdfzG+mXf4Eh6mVRCWxxt
         rQqvWh5mqw7VsHOBeU/2pFM5cthrYal6NRIs2uvjRLL5CY3i5NBvtUVZpJlS57KuwN
         OaQGq2rYintkSXzb2E1/9yPRWmA1Lgfk9bJ+3ZMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/76] tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header
Date:   Wed, 23 Nov 2022 09:50:08 +0100
Message-Id: <20221123084547.045467723@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1c075b192fe41030457cd4a5f7dea730412bca40 ]

This is a follow-up for commit 974cb0e3e7c9 ("tipc: fix uninit-value
in tipc_nl_compat_name_table_dump") where it should have type casted
sizeof(..) to int to work when TLV_GET_DATA_LEN() returns a negative
value.

syzbot reported a call trace because of it:

  BUG: KMSAN: uninit-value in ...
   tipc_nl_compat_name_table_dump+0x841/0xea0 net/tipc/netlink_compat.c:934
   __tipc_nl_compat_dumpit+0xab2/0x1320 net/tipc/netlink_compat.c:238
   tipc_nl_compat_dumpit+0x991/0xb50 net/tipc/netlink_compat.c:321
   tipc_nl_compat_recv+0xb6e/0x1640 net/tipc/netlink_compat.c:1324
   genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
   genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
   genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
   netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
   genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
   netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
   netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
   netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
   sock_sendmsg_nosec net/socket.c:714 [inline]
   sock_sendmsg net/socket.c:734 [inline]

Reported-by: syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com
Fixes: 974cb0e3e7c9 ("tipc: fix uninit-value in tipc_nl_compat_name_table_dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/ccd6a7ea801b15aec092c3b532a883b4c5708695.1667594933.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 69151de9657c..2e6c33fbd238 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -856,7 +856,7 @@ static int tipc_nl_compat_name_table_dump_header(struct tipc_nl_compat_msg *msg)
 	};
 
 	ntq = (struct tipc_name_table_query *)TLV_DATA(msg->req);
-	if (TLV_GET_DATA_LEN(msg->req) < sizeof(struct tipc_name_table_query))
+	if (TLV_GET_DATA_LEN(msg->req) < (int)sizeof(struct tipc_name_table_query))
 		return -EINVAL;
 
 	depth = ntohl(ntq->depth);
-- 
2.35.1



