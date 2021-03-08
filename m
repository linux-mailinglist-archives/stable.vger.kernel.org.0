Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5123B330E4B
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhCHMgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhCHMgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F21A651DC;
        Mon,  8 Mar 2021 12:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206960;
        bh=kK9lkfFCx3+sPUX8hp04fe9hE9KovlrHiGblLfTwEXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbSPyMgI+1aM8X/BDosExwItK/ffMI+ec3m2+0hoZV99Yf8pyUUI7tIO7iakOk/Yo
         VzfDIBXMQ/egm6HtOlR4JTHU/5rXhI+476pQmMcM24haVbfmF4ps/0Gp3vmdq3wGKc
         D0nDf9dq9HNZf2iYoPQ6j0I5j41TvXdig0FfelCs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 15/44] btrfs: validate qgroup inherit for SNAP_CREATE_V2 ioctl
Date:   Mon,  8 Mar 2021 13:34:53 +0100
Message-Id: <20210308122719.327360997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
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
@@ -1926,7 +1926,10 @@ static noinline int btrfs_ioctl_snap_cre
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
@@ -1935,6 +1938,20 @@ static noinline int btrfs_ioctl_snap_cre
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


