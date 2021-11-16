Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828B1453A0E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhKPTVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239957AbhKPTVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:21:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AA0B63223;
        Tue, 16 Nov 2021 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090296;
        bh=6olxpH6CmWrvcoDVJ347Tim/Aqpn8OAQT+0/b4Vg8Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVKp6i53XqAnocaSgi2rfVogg1x/O7r/Tq/MLrbDwDPmuNwrEIBVpsEgiSPcqA/Ac
         lY5d1tWh14QWkiTj2kUJcb7k5JOCjog6YANLU51s4H+gk9gmnh11FBZp5lwwfgaFcC
         YEnhmQ85KRwVRq+8iv8+kCRl60s9QZeXdZ7cTGn7gLN8r8qw9aQOTm1oqr/v+DkVdR
         8bmkzsDnuxNmokw3imewdzoFl3sz8Qgwjg5e7H5OfWKYoMENaqUTgPrOOAAXPZBo+Q
         3BLRFC1mTd3kLFv1tbmyFVGvRIqXw/keEsKis4UXn6y0S2mAhyZqYsyFou6uFMkrgd
         I1Va3sMTzOoCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chenyuan Mi <cymi20@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 5.15 09/65] orangefs: Fix sb refcount leak when allocate sb info failed.
Date:   Tue, 16 Nov 2021 14:16:54 -0500
Message-Id: <20211116191754.2419097-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116191754.2419097-1-sashal@kernel.org>
References: <20211116191754.2419097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenyuan Mi <cymi20@fudan.edu.cn>

[ Upstream commit ac2c63757f4f413980d6c676dbe1ae2941b94afa ]

The reference counting issue happens in one exception handling
path of orangefs_mount(). When failing to allocate sb info, the
function forgets to decrease the refcount of sb increased by
sget(), causing a refcount leak.

Fix this issue by jumping to the label "free_sb_and_op" instead
of "free_op"

Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 2f2e430461b21..c46a9005fc445 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -526,7 +526,7 @@ struct dentry *orangefs_mount(struct file_system_type *fst,
 	sb->s_fs_info = kzalloc(sizeof(struct orangefs_sb_info_s), GFP_KERNEL);
 	if (!ORANGEFS_SB(sb)) {
 		d = ERR_PTR(-ENOMEM);
-		goto free_op;
+		goto free_sb_and_op;
 	}
 
 	ret = orangefs_fill_sb(sb,
-- 
2.33.0

