Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7D4539DB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbhKPTJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239847AbhKPTID (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:08:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8C163220;
        Tue, 16 Nov 2021 19:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637089506;
        bh=6olxpH6CmWrvcoDVJ347Tim/Aqpn8OAQT+0/b4Vg8Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEvyDsgdtOBYfX4HRkcdaDgAYZx0+NF8RvvPfuc7HvDurBxCKuc66OhJdIAwDc7Gy
         PRDsQEO/vL+OGmGZwLMsiEEJBikniWpEwDTaxVxp6DurF3SHoEsefXSJKA3GCS9cGa
         FJ4xnFJ05bVmS/NWEfgNn9dgxNvAZUmi7hf0gT/BmAKgwC/65r06RDQUbtpMCddwWk
         TkzYeTz1tq38CeHLJG/eZsxKHSfpSmQQzWwribDgffYK/LAxAoIoXYRiVxXmpnktX4
         gX1e6FUEvCd8E4phW67xDthRZuWmLglYieWjtaFjMh688R5Bg2Ttt9esPRS8kC9a3F
         qb9xYIhq1RnUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chenyuan Mi <cymi20@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 5.15 09/65] orangefs: Fix sb refcount leak when allocate sb info failed.
Date:   Tue, 16 Nov 2021 14:03:29 -0500
Message-Id: <20211116190443.2418144-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116190443.2418144-1-sashal@kernel.org>
References: <20211116190443.2418144-1-sashal@kernel.org>
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

