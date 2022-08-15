Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D5E5934A6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiHOSOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiHOSNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DAC2A41B;
        Mon, 15 Aug 2022 11:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 806E7B80F99;
        Mon, 15 Aug 2022 18:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E500EC433D7;
        Mon, 15 Aug 2022 18:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587220;
        bh=c6GDu3Ar2i8zQtQGfiJEPIXMrVpY6NchdRhIyLfZxAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6/QQffIJTFrnRAWCpYbre+TEWYo3gBZV+jeskC2wt6k9MPHmzmZi2ePaF9OToQT6
         pEVhEPu6iH0iWUg4gE0KT/8wrwMAFUJ3Tba33n3o23nyKl4DueKI3/Pw/k0gTxVwGx
         N0NSmFYOgFOdNnPMLcqOaWAwOk/uI/JNRoiqXm0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kasiak <j.kasiak@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 016/779] lockd: detect and reject lock arguments that overflow
Date:   Mon, 15 Aug 2022 19:54:20 +0200
Message-Id: <20220815180337.886410440@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
 fs/lockd/svc4proc.c       |  8 ++++++++
 fs/lockd/xdr4.c           | 19 ++-----------------
 include/linux/lockd/xdr.h |  2 ++
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 4f247ab8be61..bf274f23969b 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -32,6 +32,10 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	if (!nlmsvc_ops)
 		return nlm_lck_denied_nolocks;
 
+	if (lock->lock_start > OFFSET_MAX ||
+	    (lock->lock_len && ((lock->lock_len - 1) > (OFFSET_MAX - lock->lock_start))))
+		return nlm4_fbig;
+
 	/* Obtain host handle */
 	if (!(host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len))
 	 || (argp->monitor && nsm_monitor(host) < 0))
@@ -50,6 +54,10 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
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
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 856267c0864b..712fdfeb8ef0 100644
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
@@ -81,20 +72,14 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
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
diff --git a/include/linux/lockd/xdr.h b/include/linux/lockd/xdr.h
index 398f70093cd3..67e4a2c5500b 100644
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
 
-- 
2.37.1



