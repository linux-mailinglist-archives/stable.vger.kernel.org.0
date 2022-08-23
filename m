Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C8A59D640
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbiHWJEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbiHWJD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF861C107;
        Tue, 23 Aug 2022 01:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5986132D;
        Tue, 23 Aug 2022 08:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F8CC433D6;
        Tue, 23 Aug 2022 08:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243255;
        bh=f6OXRID0uCEqVUMBcp3Ki0tg3pVmjI2z9M8ylE8p0OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYfLJNgECBwzL955JzDH34ZdKWYXmFIjyycW7GXJcIw8vVXHr94dgwxa7zPuiny0F
         FABfIqga23h2HDr1ox1soHprfdpM6RH4Ety0iBA+N+oYtoD6gmaj5WEUlVIKAYUlcW
         pB5/bdRxETVDmfttMOzYslXU/81ezE7qdTBaii5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 218/365] net: genl: fix error path memory leak in policy dumping
Date:   Tue, 23 Aug 2022 10:01:59 +0200
Message-Id: <20220823080127.307948327@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit 249801360db3dec4f73768c502192020bfddeacc upstream.

If construction of the array of policies fails when recording
non-first policy we need to unwind.

netlink_policy_dump_add_policy() itself also needs fixing as
it currently gives up on error without recording the allocated
pointer in the pstate pointer.

Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
Link: https://lore.kernel.org/r/20220816161939.577583-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/genetlink.c |    6 +++++-
 net/netlink/policy.c    |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct
 							     op.policy,
 							     op.maxattr);
 			if (err)
-				return err;
+				goto err_free_state;
 		}
 	}
 
 	if (!ctx->state)
 		return -ENODATA;
 	return 0;
+
+err_free_state:
+	netlink_policy_dump_free(ctx->state);
+	return err;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -144,7 +144,7 @@ int netlink_policy_dump_add_policy(struc
 
 	err = add_policy(&state, policy, maxtype);
 	if (err)
-		return err;
+		goto err_try_undo;
 
 	for (policy_idx = 0;
 	     policy_idx < state->n_alloc && state->policies[policy_idx].policy;
@@ -164,7 +164,7 @@ int netlink_policy_dump_add_policy(struc
 						 policy[type].nested_policy,
 						 policy[type].len);
 				if (err)
-					return err;
+					goto err_try_undo;
 				break;
 			default:
 				break;
@@ -174,6 +174,16 @@ int netlink_policy_dump_add_policy(struc
 
 	*pstate = state;
 	return 0;
+
+err_try_undo:
+	/* Try to preserve reasonable unwind semantics - if we're starting from
+	 * scratch clean up fully, otherwise record what we got and caller will.
+	 */
+	if (!*pstate)
+		netlink_policy_dump_free(state);
+	else
+		*pstate = state;
+	return err;
 }
 
 static bool


