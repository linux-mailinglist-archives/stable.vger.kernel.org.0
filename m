Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F346CC52F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbjC1PMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjC1PMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0246610259
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80BA661828
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95360C433EF;
        Tue, 28 Mar 2023 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016224;
        bh=uH+SOWvv2oxtjhLaSHvbrrXaOG6hBozL5TlbYZz59eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPWfx7u0lQum1fVlgctyGUqMYwh3Mq47E8L0zlxh0RtS9j+N1VkzBBI3UHkhX2Jdj
         IxeUSnHYu+Wvxm19x1Cntb3Y5IHqruo++HnN546MQ94AXme8XkzrAy8iF9mJTSozNq
         fd9Uckjfb02cU5VNnTBq9n+7meJCdNtOiejuFUvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.15 111/146] lockd: set file_lock start and end when decoding nlm4 testargs
Date:   Tue, 28 Mar 2023 16:43:20 +0200
Message-Id: <20230328142607.299430786@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 7ff84910c66c9144cc0de9d9deed9fb84c03aff0 upstream.

Commit 6930bcbfb6ce dropped the setting of the file_lock range when
decoding a nlm_lock off the wire. This causes the client side grant
callback to miss matching blocks and reject the lock, only to rerequest
it 30s later.

Add a helper function to set the file_lock range from the start and end
values that the protocol uses, and have the nlm_lock decoder call that to
set up the file_lock args properly.

Fixes: 6930bcbfb6ce ("lockd: detect and reject lock arguments that overflow")
Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org #6.0
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/clnt4xdr.c        |    9 +--------
 fs/lockd/xdr4.c            |   13 ++++++++++++-
 include/linux/lockd/xdr4.h |    1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -261,7 +261,6 @@ static int decode_nlm4_holder(struct xdr
 	u32 exclusive;
 	int error;
 	__be32 *p;
-	s32 end;
 
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(fl);
@@ -285,13 +284,7 @@ static int decode_nlm4_holder(struct xdr
 	fl->fl_type  = exclusive != 0 ? F_WRLCK : F_RDLCK;
 	p = xdr_decode_hyper(p, &l_offset);
 	xdr_decode_hyper(p, &l_len);
-	end = l_offset + l_len - 1;
-
-	fl->fl_start = (loff_t)l_offset;
-	if (l_len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = (loff_t)end;
+	nlm4svc_set_file_lock_range(fl, l_offset, l_len);
 	error = 0;
 out:
 	return error;
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -33,6 +33,17 @@ loff_t_to_s64(loff_t offset)
 	return res;
 }
 
+void nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len)
+{
+	s64 end = off + len - 1;
+
+	fl->fl_start = off;
+	if (len == 0 || end < 0)
+		fl->fl_end = OFFSET_MAX;
+	else
+		fl->fl_end = end;
+}
+
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -80,7 +91,7 @@ svcxdr_decode_lock(struct xdr_stream *xd
 	locks_init_lock(fl);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;
-
+	nlm4svc_set_file_lock_range(fl, lock->lock_start, lock->lock_len);
 	return true;
 }
 
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -24,6 +24,7 @@
 
 
 
+void	nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len);
 int	nlm4svc_decode_testargs(struct svc_rqst *, __be32 *);
 int	nlm4svc_encode_testres(struct svc_rqst *, __be32 *);
 int	nlm4svc_decode_lockargs(struct svc_rqst *, __be32 *);


