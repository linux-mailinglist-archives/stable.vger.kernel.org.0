Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2160D1D0E78
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733172AbgEMJwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgEMJwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B76B20753;
        Wed, 13 May 2020 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363523;
        bh=IDIvI+1772k1Od1sxCmC/aHtQx79JKNpyEUnrjOlVXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFLi1xkaOkBO/l0NImxgnmPSbepuXh8tSbLVKOf2fT+Plik4NEazpGwLOMUUrQIzE
         nfhSxw/ac5U6mYcvXh3sxuF2ULwOy4P/ediPiiVPmB0vqM+zntUw9SfOFysuA6NPjS
         fOZAL03TZSs0BlmOA5Ygh3EwR0cZTcXAOHkp294s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 019/118] mlxsw: spectrum_acl_tcam: Position vchunk in a vregion list properly
Date:   Wed, 13 May 2020 11:43:58 +0200
Message-Id: <20200513094419.427217170@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 6ef4889fc0b3aa6ab928e7565935ac6f762cee6e ]

Vregion helpers to get min and max priority depend on the correct
ordering of vchunks in the vregion list. However, the current code
always adds new chunk to the end of the list, no matter what the
priority is. Fix this by finding the correct place in the list and put
vchunk there.

Fixes: 22a677661f56 ("mlxsw: spectrum: Introduce ACL core with simple TCAM implementation")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -986,8 +986,9 @@ mlxsw_sp_acl_tcam_vchunk_create(struct m
 				unsigned int priority,
 				struct mlxsw_afk_element_usage *elusage)
 {
+	struct mlxsw_sp_acl_tcam_vchunk *vchunk, *vchunk2;
 	struct mlxsw_sp_acl_tcam_vregion *vregion;
-	struct mlxsw_sp_acl_tcam_vchunk *vchunk;
+	struct list_head *pos;
 	int err;
 
 	if (priority == MLXSW_SP_ACL_TCAM_CATCHALL_PRIO)
@@ -1025,7 +1026,14 @@ mlxsw_sp_acl_tcam_vchunk_create(struct m
 	}
 
 	mlxsw_sp_acl_tcam_rehash_ctx_vregion_changed(vregion);
-	list_add_tail(&vchunk->list, &vregion->vchunk_list);
+
+	/* Position the vchunk inside the list according to priority */
+	list_for_each(pos, &vregion->vchunk_list) {
+		vchunk2 = list_entry(pos, typeof(*vchunk2), list);
+		if (vchunk2->priority > priority)
+			break;
+	}
+	list_add_tail(&vchunk->list, pos);
 	mutex_unlock(&vregion->lock);
 
 	return vchunk;


