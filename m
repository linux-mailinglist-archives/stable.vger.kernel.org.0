Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046AA61F7D3
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiKGPj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiKGPjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:39:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEBF1F9F0
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:39:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D90CCB812A5
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1527DC433D6;
        Mon,  7 Nov 2022 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667835561;
        bh=BixIOejDFr+kqvQKQgs338XvPKlXQ7Db3w3jmvdOl2Q=;
        h=Subject:To:Cc:From:Date:From;
        b=nl/QgyBpBXaKTh/ymtDoJ/+xWjUku3bmlmWciaABD9JN6gcC/VipKp9T1xwSrDx1k
         JlmTYB+U/h1Y7wzxDbsnMjbIwtt0Dpy/vScmcXq1IzETTfspZoWnC33rPVDAXh9HCk
         Fdc/8jv7ywZFUV75aWH72A4Nu+VJDAH57t/fgUAM=
Subject: FAILED: patch "[PATCH] fuse: add file_modified() to fallocate" failed to apply to 4.14-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 16:39:16 +0100
Message-ID: <1667835556137206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4a6f278d4827 ("fuse: add file_modified() to fallocate")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a6f278d4827b59ba26ceae0ff4529ee826aa258 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Fri, 28 Oct 2022 14:25:20 +0200
Subject: [PATCH] fuse: add file_modified() to fallocate

Add missing file_modified() call to fuse_file_fallocate().  Without this
fallocate on fuse failed to clear privileges.

Fixes: 05ba1f082300 ("fuse: add FALLOCATE operation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 1a3afd469e3a..71bfb663aac5 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3001,6 +3001,10 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 			goto out;
 	}
 
+	err = file_modified(file);
+	if (err)
+		goto out;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 

