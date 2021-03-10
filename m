Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E65D333E21
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhCJNZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhCJNY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD8A64FD7;
        Wed, 10 Mar 2021 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382697;
        bh=a7SOAual/f/cgG+0y327eyUUjVQ+AkZiQCn2i5lx14I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqXocW0rA3xacug/7W+zbnZ4vlxtrsXu3BWHIlZkphax5ZZinKWBflYuokv94cnUb
         NMt0YuOnGwYcYEHBKeL3SYzFFTBduQBZZSd9zLYP63p774ab4f1DcsvU1iO25YIHRc
         eMQex7LKUCSlChsdAGOnNv+X67XadrugrnzZu3lI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 03/39] btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl
Date:   Wed, 10 Mar 2021 14:24:11 +0100
Message-Id: <20210310132319.834379173@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Dan Carpenter <dancarpenter@oracle.com>

commit 5011c5a663b9c6d6aff3d394f11049b371199627 upstream.

The problem is we're copying "inherit" from user space but we don't
necessarily know that we're copying enough data for a 64 byte
struct.  Then the next problem is that 'inherit' has a variable size
array at the end, and we have to verify that array is the size we
expected.

Fixes: 6f72c7e20dba ("Btrfs: add qgroup inheritance")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1842,7 +1842,10 @@ static noinline int btrfs_ioctl_snap_cre
 	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
 		readonly = true;
 	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
-		if (vol_args->size > PAGE_SIZE) {
+		u64 nums;
+
+		if (vol_args->size < sizeof(*inherit) ||
+		    vol_args->size > PAGE_SIZE) {
 			ret = -EINVAL;
 			goto free_args;
 		}
@@ -1851,6 +1854,20 @@ static noinline int btrfs_ioctl_snap_cre
 			ret = PTR_ERR(inherit);
 			goto free_args;
 		}
+
+		if (inherit->num_qgroups > PAGE_SIZE ||
+		    inherit->num_ref_copies > PAGE_SIZE ||
+		    inherit->num_excl_copies > PAGE_SIZE) {
+			ret = -EINVAL;
+			goto free_inherit;
+		}
+
+		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
+		       2 * inherit->num_excl_copies;
+		if (vol_args->size != struct_size(inherit, qgroups, nums)) {
+			ret = -EINVAL;
+			goto free_inherit;
+		}
 	}
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,


