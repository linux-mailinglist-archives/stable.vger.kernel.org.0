Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7017201F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbgB0NxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731292AbgB0NxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:53:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B24CC21D7E;
        Thu, 27 Feb 2020 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811580;
        bh=irBOlCATyadb56mwYwGAJouMGPdmjSyPwFVQ/95DRbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLQSQ6RJM84qtVPHNW+HMNjIYKb1bu82S97Hs4X8Q2VkCiNCnJQO0cFpan2R2XbU8
         FUDDqeOoPbI4jr81ngm+nXoFL1ce5AAZVEyemHDzKpXz4WGxiUe3t+dGzzt4n/yzKt
         mAhWSZXVIzl4149jV7ZgjM0rhTcIsvoIXHov+s3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 021/237] btrfs: log message when rw remount is attempted with unclean tree-log
Date:   Thu, 27 Feb 2020 14:33:55 +0100
Message-Id: <20200227132257.741822817@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 10a3a3edc5b89a8cd095bc63495fb1e0f42047d9 upstream.

A remount to a read-write filesystem is not safe when there's tree-log
to be replayed. Files that could be opened until now might be affected
by the changes in the tree-log.

A regular mount is needed to replay the log so the filesystem presents
the consistent view with the pending changes included.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1801,6 +1801,8 @@ static int btrfs_remount(struct super_bl
 		}
 
 		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
+			btrfs_warn(fs_info,
+		"mount required to replay tree-log, cannot remount read-write");
 			ret = -EINVAL;
 			goto restore;
 		}


