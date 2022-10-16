Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68345FFD98
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJPGpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJPGpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:45:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED98A36084;
        Sat, 15 Oct 2022 23:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61F93B80B70;
        Sun, 16 Oct 2022 06:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E9DC433D7;
        Sun, 16 Oct 2022 06:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902729;
        bh=TBeS4Ug3OnoGaH9ToiRRRWEOuovZ0kDuT+LCqlrudDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egBkgLMTXJ/Z8IbFgNnWCq1wF+MSVE29WLR1BX2IAV38bI93WclPvRRVqsNaV93r7
         vNGPoq3DkSMDKq3KXZHTTn12063jqkuadqgTA0I+d8TFvLYndGXqfSmRm/OG1adUqK
         GaklQv4xjzFG0i56fKO+eFNjqm4qap9RdECRu7cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1/4] Revert "fs: check FMODE_LSEEK to control internal pipe splicing"
Date:   Sun, 16 Oct 2022 08:46:11 +0200
Message-Id: <20221016064454.424548581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
References: <20221016064454.382206984@linuxfoundation.org>
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
index 6610e55c0e2a..866d5c2367b2 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -806,15 +806,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
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



