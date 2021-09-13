Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441EC409198
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbhIMOCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343585AbhIMOAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8849061A0B;
        Mon, 13 Sep 2021 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540258;
        bh=JkzJl0hAJVRhrvvxcHei82EQ0T772Vh7JhSWg3QvjQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELLQAE8YENVvz1wVtNu7ALGKhQXBDZBsm71kje6NA+7eFqLr82V7eBioF7/Lte8Gh
         ujbqeoCx0tl3NJIq7WPBcfvOFeVKBBMzxejy24xCiUOKJaIPzzWxzVMAkyjYY4tDEQ
         hr+xqDBmKTPQsdQIs4iVV5895oE8r51wRpTapP08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 118/300] 6lowpan: iphc: Fix an off-by-one check of array index
Date:   Mon, 13 Sep 2021 15:12:59 +0200
Message-Id: <20210913131113.390004723@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9af417610b6142e826fd1ee8ba7ff3e9a2133a5a ]

The bounds check of id is off-by-one and the comparison should
be >= rather >. Currently the WARN_ON_ONCE check does not stop
the out of range indexing of &ldev->ctx.table[id] so also add
a return path if the bounds are out of range.

Addresses-Coverity: ("Illegal address computation").
Fixes: 5609c185f24d ("6lowpan: iphc: add support for stateful compression")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/6lowpan/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
index 1c140af06d52..600b9563bfc5 100644
--- a/net/6lowpan/debugfs.c
+++ b/net/6lowpan/debugfs.c
@@ -170,7 +170,8 @@ static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
 	struct dentry *root;
 	char buf[32];
 
-	WARN_ON_ONCE(id > LOWPAN_IPHC_CTX_TABLE_SIZE);
+	if (WARN_ON_ONCE(id >= LOWPAN_IPHC_CTX_TABLE_SIZE))
+		return;
 
 	sprintf(buf, "%d", id);
 
-- 
2.30.2



