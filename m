Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBEB593C54
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiHOUG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345997AbiHOUFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5E880F73;
        Mon, 15 Aug 2022 11:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5176BB810A0;
        Mon, 15 Aug 2022 18:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B921C433C1;
        Mon, 15 Aug 2022 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589690;
        bh=2aMAS6nnDE24Xxc3BAWnHHAWPjrQi/Hpa0MkJi+LjSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dno4jnR6SlUp2YUQG245vrG4siDJafxSjea1TMs3LxAUWiPvGraXhuBgEG3S8/LUg
         jl4KNl1hzHsUZbu4ZaZbNMCoSw0ctjqYRpu685LuIhShL5GyIG9HEQdsY4PM59xHWa
         QJcQMlLKycjyzvZzG+43vVQrVgNzTr1clRt5vPr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kasiak <j.kasiak@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.18 0018/1095] lockd: detect and reject lock arguments that overflow
Date:   Mon, 15 Aug 2022 19:50:17 +0200
Message-Id: <20220815180430.097981703@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

commit 6930bcbfb6ceda63e298c6af6d733ecdf6bd4cde upstream.

lockd doesn't currently vet the start and length in nlm4 requests like
it should, and can end up generating lock requests with arguments that
overflow when passed to the filesystem.

The NLM4 protocol uses unsigned 64-bit arguments for both start and
length, whereas struct file_lock tracks the start and end as loff_t
values. By the time we get around to calling nlm4svc_retrieve_args,
we've lost the information that would allow us to determine if there was
an overflow.

Start tracking the actual start and len for NLM4 requests in the
nlm_lock. In nlm4svc_retrieve_args, vet these values to ensure they
won't cause an overflow, and return NLM4_FBIG if they do.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=392
Reported-by: Jan Kasiak <j.kasiak@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svc4proc.c       |    8 ++++++++
 fs/lockd/xdr4.c           |   19 ++-----------------
 include/linux/lockd/xdr.h |    2 ++
 3 files changed, 12 insertions(+), 17 deletions(-)

--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -32,6 +32,10 @@ nlm4svc_retrieve_args(struct svc_rqst *r
 	if (!nlmsvc_ops)
 		return nlm_lck_denied_nolocks;
 
+	if (lock->lock_start > OFFSET_MAX ||
+	    (lock->lock_len && ((lock->lock_len - 1) > (OFFSET_MAX - lock->lock_start))))
+		return nlm4_fbig;
+
 	/* Obtain host handle */
 	if (!(host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len))
 	 || (argp->monitor && nsm_monitor(host) < 0))
@@ -50,6 +54,10 @@ nlm4svc_retrieve_args(struct svc_rqst *r
 		/* Set up the missing parts of the file_lock structure */
 		lock->fl.fl_file  = file->f_file[mode];
 		lock->fl.fl_pid = current->tgid;
+		lock->fl.fl_start = (loff_t)lock->lock_start;
+		lock->fl.fl_end = lock->lock_len ?
+				   (loff_t)(lock->lock_start + lock->lock_len - 1) :
+				   OFFSET_MAX;
 		lock->fl.fl_lmops = &nlmsvc_lock_operations;
 		nlmsvc_locks_init_private(&lock->fl, host, (pid_t)lock->svid);
 		if (!lock->fl.fl_owner) {
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -20,13 +20,6 @@
 
 #include "svcxdr.h"
 
-static inline loff_t
-s64_to_loff_t(__s64 offset)
-{
-	return (loff_t)offset;
-}
-
-
 static inline s64
 loff_t_to_s64(loff_t offset)
 {
@@ -70,8 +63,6 @@ static bool
 svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 {
 	struct file_lock *fl = &lock->fl;
-	u64 len, start;
-	s64 end;
 
 	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
 		return false;
@@ -81,20 +72,14 @@ svcxdr_decode_lock(struct xdr_stream *xd
 		return false;
 	if (xdr_stream_decode_u32(xdr, &lock->svid) < 0)
 		return false;
-	if (xdr_stream_decode_u64(xdr, &start) < 0)
+	if (xdr_stream_decode_u64(xdr, &lock->lock_start) < 0)
 		return false;
-	if (xdr_stream_decode_u64(xdr, &len) < 0)
+	if (xdr_stream_decode_u64(xdr, &lock->lock_len) < 0)
 		return false;
 
 	locks_init_lock(fl);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;
-	end = start + len - 1;
-	fl->fl_start = s64_to_loff_t(start);
-	if (len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = s64_to_loff_t(end);
 
 	return true;
 }
--- a/include/linux/lockd/xdr.h
+++ b/include/linux/lockd/xdr.h
@@ -41,6 +41,8 @@ struct nlm_lock {
 	struct nfs_fh		fh;
 	struct xdr_netobj	oh;
 	u32			svid;
+	u64			lock_start;
+	u64			lock_len;
 	struct file_lock	fl;
 };
 


