Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B589959D5D9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243922AbiHWIdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346992AbiHWIcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337C374E23;
        Tue, 23 Aug 2022 01:16:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CA5661238;
        Tue, 23 Aug 2022 08:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3950CC433D6;
        Tue, 23 Aug 2022 08:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242581;
        bh=2cnvJBgNQeP6YaccfYEAUaqtV2LiY3X/dI5JdqXJ8wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrNftSmdBrA1CMyT/AtlPjCXCt3aB9jixH8LfdZC8Qho5k3PCqJWuccGBAaho/p4D
         KvbpghxthJWGfRMftJmY4spTP1dQGTyh8tfTL/8Usb2VxGsznRvF/tinwB4Rc2610Q
         j2jccqHnxfX29fYu/TP6Q6qG7+UL5uuJqF6Mx378=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.19 140/365] ceph: dont leak snap_rwsem in handle_cap_grant
Date:   Tue, 23 Aug 2022 10:00:41 +0200
Message-Id: <20220823080124.073498675@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 58dd4385577ed7969b80cdc9e2a31575aba6c712 upstream.

When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
held and the function is expected to release it before returning. It
currently fails to do that in all cases which could lead to a deadlock.

Fixes: 6f05b30ea063 ("ceph: reset i_requested_max_size if file write is not wanted")
Link: https://tracker.ceph.com/issues/55857
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3578,24 +3578,23 @@ static void handle_cap_grant(struct inod
 			fill_inline = true;
 	}
 
-	if (ci->i_auth_cap == cap &&
-	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
-		if (newcaps & ~extra_info->issued)
-			wake = true;
+	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
+		if (ci->i_auth_cap == cap) {
+			if (newcaps & ~extra_info->issued)
+				wake = true;
 
-		if (ci->i_requested_max_size > max_size ||
-		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
-			/* re-request max_size if necessary */
-			ci->i_requested_max_size = 0;
-			wake = true;
-		}
+			if (ci->i_requested_max_size > max_size ||
+			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
+				/* re-request max_size if necessary */
+				ci->i_requested_max_size = 0;
+				wake = true;
+			}
 
-		ceph_kick_flushing_inode_caps(session, ci);
-		spin_unlock(&ci->i_ceph_lock);
+			ceph_kick_flushing_inode_caps(session, ci);
+		}
 		up_read(&session->s_mdsc->snap_rwsem);
-	} else {
-		spin_unlock(&ci->i_ceph_lock);
 	}
+	spin_unlock(&ci->i_ceph_lock);
 
 	if (fill_inline)
 		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,


