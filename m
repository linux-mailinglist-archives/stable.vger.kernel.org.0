Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976BA6BB01D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjCOMP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjCOMPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFEB76057
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 593E9CE19B7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBD7C433D2;
        Wed, 15 Mar 2023 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882519;
        bh=z/iFusAiSLpPLwdVFESAgq2RXBmDbfYvFSycz6MVXJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/6yj6FQMOEfHVVpAsSe0Ya4I6hDUwwk1ezC99DpC7AN1q/VK/B1U56/IYkt9Ghwo
         aaQxhLt59T230tM5Ox8HTvvo4jOfYDPUAnNpHGstH7DP+DeMajRuo1QCH+u/3YxPlb
         bGCpoMzai8fpPavDNFhhcZdXN5OyWjvG5WRHiMAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Theodore Tso <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 01/39] fs: prevent out-of-bounds array speculation when closing a file descriptor
Date:   Wed, 15 Mar 2023 13:12:15 +0100
Message-Id: <20230315115721.295721286@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 609d54441493c99f21c1823dfd66fa7f4c512ff4 upstream.

Google-Bug-Id: 114199369
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -627,6 +627,7 @@ int __close_fd(struct files_struct *file
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;


