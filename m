Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69589608718
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiJVH4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiJVHyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4EF951F8;
        Sat, 22 Oct 2022 00:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A268AB82E21;
        Sat, 22 Oct 2022 07:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAF1C433D6;
        Sat, 22 Oct 2022 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424798;
        bh=jOc7LW7IWzijjP0DhfLG0KzytqA6AuX/PkOEIoEOpsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0sEyyisHfz028LOIqlDOr8exRAAq+I6Q9n5IMQPbcM7wZu7ECXIbkiyRKKwE8Mz+
         idRsZHehtujP2Z0OhVRmg/VcXmMDOgK+SfW1LInJUO+++kM1t+iEhlZ8+ldZs03Fau
         qcfgRz6kn0Dp6tWSLqdZkJAMhjLVvDjhxdK98Gn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 280/717] sctp: handle the error returned from sctp_auth_asoc_init_active_key
Date:   Sat, 22 Oct 2022 09:22:39 +0200
Message-Id: <20221022072503.424041248@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 022152aaebe116a25c39818a07e175a8cd3c1e11 ]

When it returns an error from sctp_auth_asoc_init_active_key(), the
active_key is actually not updated. The old sh_key will be freeed
while it's still used as active key in asoc. Then an use-after-free
will be triggered when sending patckets, as found by syzbot:

  sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
  sctp_set_owner_w net/sctp/socket.c:132 [inline]
  sctp_sendmsg_to_asoc+0xbd5/0x1a20 net/sctp/socket.c:1863
  sctp_sendmsg+0x1053/0x1d50 net/sctp/socket.c:2025
  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
  sock_sendmsg_nosec net/socket.c:714 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:734

This patch is to fix it by not replacing the sh_key when it returns
errors from sctp_auth_asoc_init_active_key() in sctp_auth_set_key().
For sctp_auth_set_active_key(), old active_key_id will be set back
to asoc->active_key_id when the same thing happens.

Fixes: 58acd1009226 ("sctp: update active_key for asoc when old key is being replaced")
Reported-by: syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/auth.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index db6b7373d16c..34964145514e 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -863,12 +863,17 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 	}
 
 	list_del_init(&shkey->key_list);
-	sctp_auth_shkey_release(shkey);
 	list_add(&cur_key->key_list, sh_keys);
 
-	if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+	if (asoc && asoc->active_key_id == auth_key->sca_keynumber &&
+	    sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+		list_del_init(&cur_key->key_list);
+		sctp_auth_shkey_release(cur_key);
+		list_add(&shkey->key_list, sh_keys);
+		return -ENOMEM;
+	}
 
+	sctp_auth_shkey_release(shkey);
 	return 0;
 }
 
@@ -902,8 +907,13 @@ int sctp_auth_set_active_key(struct sctp_endpoint *ep,
 		return -EINVAL;
 
 	if (asoc) {
+		__u16  active_key_id = asoc->active_key_id;
+
 		asoc->active_key_id = key_id;
-		sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
+		if (sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL)) {
+			asoc->active_key_id = active_key_id;
+			return -ENOMEM;
+		}
 	} else
 		ep->active_key_id = key_id;
 
-- 
2.35.1



