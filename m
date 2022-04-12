Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D24FD1AF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351088AbiDLG77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351458AbiDLG6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:58:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3FD42A0E;
        Mon, 11 Apr 2022 23:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74C6660A21;
        Tue, 12 Apr 2022 06:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A50DC385A1;
        Tue, 12 Apr 2022 06:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745991;
        bh=xFvb53Si9ghVV5c0ZgaZzZneJoNLT2VDq2rumVQsZ/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbwUvZk7Jz3da+/kG4VNLHz/bYgVztjeuOOUWWU6JtwJZGoSyajljvhNGMYCRSmNh
         A1B90//VH4mZbC2/HAn2NIQGgHY9Ek14+Uo0iASRFLyMMlR1tz7xwzJJL2v2j8rINb
         zUBb+GvDF2EYPgToshnVGhP2733xK6Pxle1k3uYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/277] NFSv4.2: fix reference count leaks in _nfs42_proc_copy_notify()
Date:   Tue, 12 Apr 2022 08:28:44 +0200
Message-Id: <20220412062945.542618278@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit b7f114edd54326f730a754547e7cfb197b5bc132 ]

[You don't often get email from xiongx18@fudan.edu.cn. Learn why this is important at http://aka.ms/LearnAboutSenderIdentification.]

The reference counting issue happens in two error paths in the
function _nfs42_proc_copy_notify(). In both error paths, the function
simply returns the error code and forgets to balance the refcount of
object `ctx`, bumped by get_nfs_open_context() earlier, which may
cause refcount leaks.

Fix it by balancing refcount of the `ctx` object before the function
returns in both error paths.

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 9865b5c37d88..93f4d8257525 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -586,8 +586,10 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 
 	ctx = get_nfs_open_context(nfs_file_open_context(src));
 	l_ctx = nfs_get_lock_context(ctx);
-	if (IS_ERR(l_ctx))
-		return PTR_ERR(l_ctx);
+	if (IS_ERR(l_ctx)) {
+		status = PTR_ERR(l_ctx);
+		goto out;
+	}
 
 	status = nfs4_set_rw_stateid(&args->cna_src_stateid, ctx, l_ctx,
 				     FMODE_READ);
@@ -595,7 +597,7 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 	if (status) {
 		if (status == -EAGAIN)
 			status = -NFS4ERR_BAD_STATEID;
-		return status;
+		goto out;
 	}
 
 	status = nfs4_call_sync(src_server->client, src_server, &msg,
@@ -603,6 +605,7 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 	if (status == -ENOTSUPP)
 		src_server->caps &= ~NFS_CAP_COPY_NOTIFY;
 
+out:
 	put_nfs_open_context(nfs_file_open_context(src));
 	return status;
 }
-- 
2.35.1



