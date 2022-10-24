Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB92360A5C8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiJXM2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiJXM2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:28:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC69A86896;
        Mon, 24 Oct 2022 05:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8E3BB811C5;
        Mon, 24 Oct 2022 11:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D74C433D6;
        Mon, 24 Oct 2022 11:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612706;
        bh=86Bdj7WnZgq0vHTIPVC4gQ4G8vTZJzy4bM/p2YB3db0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWuJ3vJATPhOA6jpqFVOOXwNcxB3/JokuZY06Josn6pCiHCOCbnLumtVseY++zja0
         DciItruDjKNoR5Dr3kvd5f393Fopi5/CSXPeE+dmQ7tGHGNzWQnxbuCZThhPLqAqBI
         KfdUYxYOPmVdv6JBDsxmyN3vEPXR+rIoSvIJE2d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/229] Revert "fs: check FMODE_LSEEK to control internal pipe splicing"
Date:   Mon, 24 Oct 2022 13:29:28 +0200
Message-Id: <20221024113000.669471664@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 fs/splice.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -899,15 +899,17 @@ ssize_t splice_direct_to_actor(struct fi
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


