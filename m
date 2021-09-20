Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2D1411CA3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347188AbhITRLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346971AbhITRJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE84561355;
        Mon, 20 Sep 2021 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156987;
        bh=JpbPBK8nIVHG+mB7ddxJFkNNZQ60kds76dQsgpu/pWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXlLSukPZO+XHfq347iV6nkEEKqJ+kf3cf8co/7UUds395mxCyKVMFidEmljAy6pK
         M8CwXIgM3nkCAMRI/b2aQSUblczzgwM/bNd/Heqni/abTQj0d2VyPnoF5uEpMLr6aG
         VFhd3s2vG4AE2eGEl8qGVnQks/Ul/81mfkUYDO+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 146/175] net: fix NULL pointer reference in cipso_v4_doi_free
Date:   Mon, 20 Sep 2021 18:43:15 +0200
Message-Id: <20210920163922.845914092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]

In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
failed, we sometime observe panic:

  BUG: kernel NULL pointer dereference, address:
  ...
  RIP: 0010:cipso_v4_doi_free+0x3a/0x80
  ...
  Call Trace:
   netlbl_cipsov4_add_std+0xf4/0x8c0
   netlbl_cipsov4_add+0x13f/0x1b0
   genl_family_rcv_msg_doit.isra.15+0x132/0x170
   genl_rcv_msg+0x125/0x240

This is because in cipso_v4_doi_free() there is no check
on 'doi_def->map.std' when 'doi_def->type' equal 1, which
is possibe, since netlbl_cipsov4_add_std() haven't initialize
it before alloc 'doi_def->map.std'.

This patch just add the check to prevent panic happen for similar
cases.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_cipso_v4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index d31cd4d509ca..422fac2a4a3c 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -163,8 +163,8 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		return -ENOMEM;
 	doi_def->map.std = kzalloc(sizeof(*doi_def->map.std), GFP_KERNEL);
 	if (doi_def->map.std == NULL) {
-		ret_val = -ENOMEM;
-		goto add_std_failure;
+		kfree(doi_def);
+		return -ENOMEM;
 	}
 	doi_def->type = CIPSO_V4_MAP_TRANS;
 
-- 
2.30.2



