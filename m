Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0415C412082
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349757AbhITRzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349362AbhITRwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:52:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21FDA610A0;
        Mon, 20 Sep 2021 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157981;
        bh=MPMcRJrVjbsYHasSZhk3QNA1PF7C4B/jNbrGzoPLMB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD6OheWbRUi8iA4PUTic8pgwnJfW+9FAUAxGPAFcjF02Ta/O3IsotAXw7nJcLZcM+
         L3ItH8Ar5EKOfZrRen0jJwbPLPHwpKJhu1n35YthRyCwe4K1r5WP28eFcz4OMLTuch
         OcTjQPLru15clxVsugmd7RVSYHjao9CoCHLHmTc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Michael Wang <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/293] net: fix NULL pointer reference in cipso_v4_doi_free
Date:   Mon, 20 Sep 2021 18:43:21 +0200
Message-Id: <20210920163941.576383848@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 0559d442ad80..e252f62bb8c2 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -156,8 +156,8 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
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



