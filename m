Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C542653D0BF
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346903AbiFCSJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347230AbiFCSFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251DC5AEFB;
        Fri,  3 Jun 2022 10:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B352460F32;
        Fri,  3 Jun 2022 17:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6834C385A9;
        Fri,  3 Jun 2022 17:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279117;
        bh=TdDP+Db7xcOWnxSQDmXme3EoRbglcHsVWz0Cb2tdDok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GGiT48c9o8FpYMPtwhYMq4qKLVjbAk6O5NQVmlyKIjGcUtUVynC2+TzH/B5t7aBs
         DpLw6l9s9TfEZOGVurHNlKlgJZvWEt1XN1o9Q9bzp1Ew7qQcYeWkPoFu8mJAeD5Pih
         uUNjmsT0UtLmjMTc5awPTto6z6d8l7HxH2O/6uC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.18 58/67] NFSD: Fix possible sleep during nfsd4_release_lockowner()
Date:   Fri,  3 Jun 2022 19:43:59 +0200
Message-Id: <20220603173822.393586749@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit ce3c4ad7f4ce5db7b4f08a1e237d8dd94b39180b upstream.

nfsd4_release_lockowner() holds clp->cl_lock when it calls
check_for_locks(). However, check_for_locks() calls nfsd_file_get()
/ nfsd_file_put() to access the backing inode's flc_posix list, and
nfsd_file_put() can sleep if the inode was recently removed.

Let's instead rely on the stateowner's reference count to gate
whether the release is permitted. This should be a reliable
indication of locks-in-use since file lock operations and
->lm_get_owner take appropriate references, which are released
appropriately when file locks are removed.

Reported-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7330,16 +7330,12 @@ nfsd4_release_lockowner(struct svc_rqst
 		if (sop->so_is_open_owner || !same_owner_str(sop, owner))
 			continue;
 
-		/* see if there are still any locks associated with it */
-		lo = lockowner(sop);
-		list_for_each_entry(stp, &sop->so_stateids, st_perstateowner) {
-			if (check_for_locks(stp->st_stid.sc_file, lo)) {
-				status = nfserr_locks_held;
-				spin_unlock(&clp->cl_lock);
-				return status;
-			}
+		if (atomic_read(&sop->so_count) != 1) {
+			spin_unlock(&clp->cl_lock);
+			return nfserr_locks_held;
 		}
 
+		lo = lockowner(sop);
 		nfs4_get_stateowner(sop);
 		break;
 	}


