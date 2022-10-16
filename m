Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144135FFDA2
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJPGqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiJPGpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCD239BBF;
        Sat, 15 Oct 2022 23:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7CF5B80B65;
        Sun, 16 Oct 2022 06:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EBBC433D6;
        Sun, 16 Oct 2022 06:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902748;
        bh=sa1BrCIQpAgAdJX5QPqJfEmmnRdLvrQoemUIm8UpK2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kD0R8KiFrc08z00Kho736VfYlk9XRw1jxr3gfCtwFLOnZOISa/NaFZryJ9/oGwJm/
         BU0Rj/uiR6uOJaUAnfEs5lzlkl3WBluW3p4+0eB4q2iZR3uzF6KacnPXWgsOmWxiYT
         +beI+CXCabJ/uDBV87O5S+ORKPMTW5Mt9rxZ2LGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 1/4] Revert "fs: check FMODE_LSEEK to control internal pipe splicing"
Date:   Sun, 16 Oct 2022 08:46:23 +0200
Message-Id: <20221016064454.369430347@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
References: <20221016064454.327821011@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

This reverts commit fd0a6e99b61e6c08fa5cf585d54fd956f70c73a6.

Which was upstream commit 97ef77c52b789ec1411d360ed99dca1efe4b2c81.

The commit is missing dependencies and breaks NFS tests, remove it for
now.

Reported-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index ae5623244d5e..e509239d7e06 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -895,15 +895,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 {
 	struct pipe_inode_info *pipe;
 	long ret, bytes;
+	umode_t i_mode;
 	size_t len;
 	int i, flags, more;
 
 	/*
-	 * We require the input to be seekable, as we don't want to randomly
-	 * drop data for eg socket -> socket splicing. Use the piped splicing
-	 * for that!
+	 * We require the input being a regular file, as we don't want to
+	 * randomly drop data for eg socket -> socket splicing. Use the
+	 * piped splicing for that!
 	 */
-	if (unlikely(!(in->f_mode & FMODE_LSEEK)))
+	i_mode = file_inode(in)->i_mode;
+	if (unlikely(!S_ISREG(i_mode) && !S_ISBLK(i_mode)))
 		return -EINVAL;
 
 	/*
-- 
2.35.1



