Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0F059D99A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbiHWJ6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351875AbiHWJ4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71BDA0245;
        Tue, 23 Aug 2022 01:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC25B81C4A;
        Tue, 23 Aug 2022 08:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FBBC433C1;
        Tue, 23 Aug 2022 08:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244417;
        bh=IlML5BhgXcyYFKy7G8edm5CF0jBpBH9INMfPCqLaPMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Szz4MI1dwNQ0c/21/kFNWDNz4AVZtwGMW4qTwsEAJuDGsJ/ALd7pN2R+Eo4moJXFx
         hIEtL+D/W3XweeEmU3zvhe1hHr4jMJZIqskj0lAnQj67LHcWqkN0GV4ZFdHf6w2yzk
         RaARfIclSfggq5lJumslNMoS2B829jBFd3Helmgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 091/244] ceph: dont leak snap_rwsem in handle_cap_grant
Date:   Tue, 23 Aug 2022 10:24:10 +0200
Message-Id: <20220823080102.055581012@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -3543,24 +3543,23 @@ static void handle_cap_grant(struct inod
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


