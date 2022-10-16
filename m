Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAFE5FFE02
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPHgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJPHg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:36:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09CE37406
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80CB8B80B35
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECEBC433C1;
        Sun, 16 Oct 2022 07:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665905785;
        bh=SPJbvuCdQmgGR3KiK6bg4q9EOyG/SXxlZ8GlKL31+Us=;
        h=Subject:To:Cc:From:Date:From;
        b=o1XsiTroHpIOTmPFKxANt09sinnrhsVDhrA+pYOGaZJNr97qS0XoU/ESJaY0qm50Y
         f5jlP7TtLvZQcA0UqTZiOSzAQ/fSGdL8vAc7ViMlQNODFE+oiaAJnyUjcGbbcpC4AF
         4fqQa4NNKrvkS48uV1+0wyMcqWQyk/vDMJRWVPLc=
Subject: FAILED: patch "[PATCH] cifs: destage dirty pages before re-reading them for" failed to apply to 4.19-stable tree
To:     lsahlber@redhat.com, ematsumiya@suse.de, pc@cjr.nz,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:37:03 +0200
Message-ID: <1665905823142212@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

bb44c31cdcac ("cifs: destage dirty pages before re-reading them for cache=none")
6e6e2b86c29c ("CIFS: Add support for direct I/O read")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bb44c31cdcac107344dd2fcc3bd0504a53575c51 Mon Sep 17 00:00:00 2001
From: Ronnie Sahlberg <lsahlber@redhat.com>
Date: Tue, 20 Sep 2022 14:32:02 +1000
Subject: [PATCH] cifs: destage dirty pages before re-reading them for
 cache=none

This is the opposite case of kernel bugzilla 216301.
If we mmap a file using cache=none and then proceed to update the mmapped
area these updates are not reflected in a later pread() of that part of the
file.
To fix this we must first destage any dirty pages in the range before
we allow the pread() to proceed.

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6f38b134a346..7d756721e1a6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
 		len = ctx->len;
 	}
 
+	if (direct) {
+		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
+						  offset, offset + len - 1);
+		if (rc) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return -EAGAIN;
+		}
+	}
+
 	/* grab a lock here due to read response handlers can access ctx */
 	mutex_lock(&ctx->aio_mutex);
 

