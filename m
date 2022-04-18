Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDC25050D7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbiDRM3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiDRM1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC321EC65;
        Mon, 18 Apr 2022 05:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C513B80ED6;
        Mon, 18 Apr 2022 12:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC30C385A7;
        Mon, 18 Apr 2022 12:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284478;
        bh=8SqvZhAm9GgYk4tLt5NL2+jGirUP/h3bRxJS6zUKqhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBWglDbNh6IybCv1gPKAR438rxQJkPq/2d7Tc2WBVoP7IeuiRzVLPf/bYwaMNAk67
         DW3zpIN3WE5HrIAdaKIoh72fVzepm8mpZJX+5VlEb+Xo0U3DmFBXS6asMrqJXFmEfV
         UMa3NtoQQ1OyYPfNHfgXD6JCadsNI0YcSLPEF1sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 128/219] io_uring: abort file assignment prior to assigning creds
Date:   Mon, 18 Apr 2022 14:11:37 +0200
Message-Id: <20220418121210.479578704@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 701521403cfb228536b3947035c8a6eca40d8e58 ]

We need to either restore creds properly if we fail on the file
assignment, or just do the file assignment first instead. Let's do
the latter as it's simpler, should make no difference here for
file assignment.

Link: https://lore.kernel.org/lkml/000000000000a7edb305dca75a50@google.com/
Reported-by: syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com
Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a652c8eeed2..6f93bff7633c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6729,13 +6729,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
+	if (unlikely(!io_assign_file(req, issue_flags)))
+		return -EBADF;
+
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
 	if (!io_op_defs[req->opcode].audit_skip)
 		audit_uring_entry(req->opcode);
-	if (unlikely(!io_assign_file(req, issue_flags)))
-		return -EBADF;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-- 
2.35.1



