Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C432AB9E5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbgKINNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731621AbgKINNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:13:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C3220663;
        Mon,  9 Nov 2020 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927618;
        bh=CVemovo84l06d2htmBBz1T2WdlAFJvJ202kE0H7Qbgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wcscH94rDOB4icAPkKRuPNxMrqCv285nfhS/avdfJykCjbg4fDoWuUeXwuIKT39t
         lT+nowZPiRnbJ9pR2TBf8LEFgh4F8E1cTw5ARhBs5uKc9X2hn2P77rZAY09ki5wpSF
         e0a56gy6ENibQ0xuPQ5PHgBFPmtIybVePSlJH0LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/85] blk-cgroup: Fix memleak on error path
Date:   Mon,  9 Nov 2020 13:55:46 +0100
Message-Id: <20201109125024.937551375@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 52abfcbd57eefdd54737fc8c2dc79d8f46d4a3e5 ]

If new_blkg allocation raced with blk_policy change and
blkg_lookup_check fails, new_blkg is leaked.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0c7addcd19859..a4793cfb68f28 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -861,6 +861,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		blkg = blkg_lookup_check(pos, pol, q);
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
+			blkg_free(new_blkg);
 			goto fail_unlock;
 		}
 
-- 
2.27.0



