Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372CA37CDED
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245301AbhELQ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244142AbhELQmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 453AB61D21;
        Wed, 12 May 2021 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835861;
        bh=BpuHsBdiHvsOm/9xUEuqFgOyCw9YBAgPRnHErjHQwGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDeSlJLpvuHVZdOmMyjo0G9iebxYMLv+iPHdEuVT6snalOkPkZiTAoai3RWbDX680
         8RFPCUPPQcz+lj1oENm0ob2Loadj2glUNjM3Ee2qDpHDZeIXe+zbLj+ekmhuxYusYn
         pEVaN09ywL9FIKhnFh5dac8FklcorOiT2gt9uw4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 514/677] xfs: fix return of uninitialized value in variable error
Date:   Wed, 12 May 2021 16:49:20 +0200
Message-Id: <20210512144854.464702591@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 3b6dd9a9aeeada19d0c820ff68e979243a888bb6 ]

A previous commit removed a call to xfs_attr3_leaf_read that
assigned an error return code to variable error. We now have
a few early error return paths to label 'out' that return
error if error is set; however error now is uninitialized
so potentially garbage is being returned.  Fix this by setting
error to zero to restore the original behaviour where error
was zero at the label 'restart'.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 472b3039eabb..902e5f7e6642 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -928,6 +928,7 @@ restart:
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
+	error = 0;
 	retval = xfs_attr_node_hasname(args, &state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		goto out;
-- 
2.30.2



