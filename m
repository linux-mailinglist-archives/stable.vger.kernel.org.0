Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF902594D2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbgIAPn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731662AbgIAPnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ECD02064B;
        Tue,  1 Sep 2020 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975005;
        bh=ukAhhZLGcZJgPOHbIw4D9BthzjRJ0aN9j3wuwKiRUL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOvm8VuugKE9cC+j8Z+jcTAsBgtq9fJJUGE6R4pCVniNhB6dMIkI8SO/JoOljdN75
         tMB5uqpi6yAG3gFVlm88zL6U9GxJ73fcPg9bqsvxUaxycHuBBPUf8qk7YGGB9mwW14
         n5nkxnHC+BZ+wFVVGL29JVukusPVSprxdc5Finp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 172/255] btrfs: reset compression level for lzo on remount
Date:   Tue,  1 Sep 2020 17:10:28 +0200
Message-Id: <20200901151008.936048011@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit 282dd7d7718444679b046b769d872b188818ca35 upstream.

Currently a user can set mount "-o compress" which will set the
compression algorithm to zlib, and use the default compress level for
zlib (3):

  relatime,compress=zlib:3,space_cache

If the user remounts the fs using "-o compress=lzo", then the old
compress_level is used:

  relatime,compress=lzo:3,space_cache

But lzo does not expose any tunable compression level. The same happens
if we set any compress argument with different level, also with zstd.

Fix this by resetting the compress_level when compress=lzo is
specified.  With the fix applied, lzo is shown without compress level:

  relatime,compress=lzo,space_cache

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -558,6 +558,7 @@ int btrfs_parse_options(struct btrfs_fs_
 			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+				info->compress_level = 0;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);


