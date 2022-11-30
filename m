Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C92363DFD6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiK3SvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiK3Suw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DC29D823
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 324AFB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DAEC433C1;
        Wed, 30 Nov 2022 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834248;
        bh=tVYiFKwPcnQUHJ1gwGc/18utRcHek+UArW1VjVo3Gow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XblllFjsTPYKos0aqpaw1fp7jed7T5tinNEvXrjYfDxxcJyjVnOTfHYrFCaXyKbID
         b5KKOMECA4osxlnqqoczQ3Es6dK8n6h1wocyhl0kZS4DX44hj42rk4cUuX+cjmikRs
         jbFsw/YtZ2WFUf50dq7s3tczC8plK4DiiS4tmLrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 184/289] NFSD: Fix reads with a non-zero offset that dont end on a page boundary
Date:   Wed, 30 Nov 2022 19:22:49 +0100
Message-Id: <20221130180548.297228210@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ac8db824ead0de2e9111337c401409d010fba2f0 ]

This was found when virtual machines with nfs-mounted qcow2 disks
failed to boot properly.

Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142132
Fixes: bfbfb6182ad1 ("nfsd_splice_actor(): handle compound pages")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index fc17b0ac8729..f3cd614e1f1e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -847,10 +847,11 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct svc_rqst *rqstp = sd->u.data;
 	struct page *page = buf->page;	// may be a compound one
 	unsigned offset = buf->offset;
+	struct page *last_page;
 
-	page += offset / PAGE_SIZE;
-	for (int i = sd->len; i > 0; i -= PAGE_SIZE)
-		svc_rqst_replace_page(rqstp, page++);
+	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
+	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+		svc_rqst_replace_page(rqstp, page);
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
-- 
2.35.1



