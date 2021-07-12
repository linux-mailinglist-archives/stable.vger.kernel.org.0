Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D093C47D0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhGLGfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237171AbhGLGeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 032B86115C;
        Mon, 12 Jul 2021 06:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071429;
        bh=u1kBf21BtJq7DPqJw+4p5bl8KyOcfXfSz94Zj0QySc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMgl3KpJlKaoBgZ3R0CTFAAbGkH421oTXuNV6KLrE/X9GT3BVKz1x5RYV8g6DGF68
         jG5XBJ7VNm/AKodUp7dlAP1UnCdV86DzuKgDjPvl1w4oSJLAMRThbL3Z+oY7+kX1at
         RzKkQfz4iYum4micH3pMN/GcoxEpS+CLP1rUfEnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.10 028/593] gfs2: Fix error handling in init_statfs
Date:   Mon, 12 Jul 2021 08:03:08 +0200
Message-Id: <20210712060846.282306392@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 5d49d3508b3c67201bd3e1bf7f4ef049111b7051 upstream.

On an error path, init_statfs calls iput(pn) after pn has already been put.
Fix that by setting pn to NULL after the initial iput.

Fixes: 97fd734ba17e ("gfs2: lookup local statfs inodes prior to journal recovery")
Cc: stable@vger.kernel.org # v5.10+
Reported-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/ops_fstype.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -670,6 +670,7 @@ static int init_statfs(struct gfs2_sbd *
 	}
 
 	iput(pn);
+	pn = NULL;
 	ip = GFS2_I(sdp->sd_sc_inode);
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0,
 				   &sdp->sd_sc_gh);


