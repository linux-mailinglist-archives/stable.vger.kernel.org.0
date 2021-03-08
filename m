Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A50330DD9
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhCHMdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCHMdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:33:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C313364EBC;
        Mon,  8 Mar 2021 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206805;
        bh=wzhuPkANCXCaekNYRQaxmpc/vxCAdUc0q3IvCWdgKbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQRe60Z0n2M2BJ8KYlxnJFi7lBNtiHdcFAttnpSSwNY+nXRVSoTtH3UHv2GD6Rqe3
         Yb6KOvPm9GGpKRdqW1V2KR3IBJTvzMLgY3EOz/pYuY4mLsk43zmfcEx9n2lW1AB2A7
         4kmJO71zuej91T2R8xwnTosXs9ZOHxByM+OfREMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 12/42] btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl
Date:   Mon,  8 Mar 2021 13:30:38 +0100
Message-Id: <20210308122718.731384148@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -1914,7 +1914,10 @@ static noinline int btrfs_ioctl_snap_cre
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
@@ -1923,6 +1926,20 @@ static noinline int btrfs_ioctl_snap_cre
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
 
 	ret = __btrfs_ioctl_snap_create(file, vol_args->name, vol_args->fd,


