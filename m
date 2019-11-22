Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63F61062DC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbfKVGCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729579AbfKVGCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A98782070B;
        Fri, 22 Nov 2019 06:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402525;
        bh=rbDfZ37pyFkTziq+H9O55VekzIqVmSm6qVNT7/Ygp88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dta8erRlPhaceZ2xiW/nDD/xWpOsC1qsFLbxMClcQMD3l6AioQETl6TdL/TXiqMPo
         XvpJk9Vt3dYLFr2dd5L8d8NWpvKpjqqL3Ekd/CNqB77P6TFZzXZKdh9Scm/YkxFIym
         WsVLGQKtNIJzxEfpC4SmZGNnU/ZqS+DcolhI2b9w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.9 33/91] gfs2: take jdata unstuff into account in do_grow
Date:   Fri, 22 Nov 2019 01:00:31 -0500
Message-Id: <20191122060129.4239-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit bc0205612bbd4dd4026d4ba6287f5643c37366ec ]

Before this patch, function do_grow would not reserve enough journal
blocks in the transaction to unstuff jdata files while growing them.
This patch adds the logic to add one more block if the file to grow
is jdata.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 39af17b407f00..d83e99fa98b3a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1236,6 +1236,8 @@ static int do_grow(struct inode *inode, u64 size)
 	}
 
 	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT +
+				 (unstuff &&
+				  gfs2_is_jdata(ip) ? RES_JDATA : 0) +
 				 (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF ?
 				  0 : RES_QUOTA), 0);
 	if (error)
-- 
2.20.1

