Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40876328CAD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhCAS5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240401AbhCASvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:51:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E0E265040;
        Mon,  1 Mar 2021 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618886;
        bh=fh5/Uoyct62QSNSQXk+ZNuM05QgM0prEHQc1bbcyCbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMyoHMyybCHHFWoDgqFtFl/V22mZpT7iv/1yC9s4iVntjlYpTLlfVgJNYSScXaTZt
         fb6kVXTyJhTVxGjzFXj58yrNLk45T1omvbo83EkS1owUOA1Zx6dIAwECSiJOiZvTWf
         qKM3z1hTQJs9q6SHHI4ilfxUBPMIzUGPgQco7fww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/663] ubifs: Fix error return code in alloc_wbufs()
Date:   Mon,  1 Mar 2021 17:08:21 +0100
Message-Id: <20210301161154.344134066@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 42119dbe571eb419dae99b81dd20fa42f47464e1 ]

Fix to return PTR_ERR() error code from the error handling case instead
fo 0 in function alloc_wbufs(), as done elsewhere in this function.

Fixes: 6a98bc4614de ("ubifs: Add authentication nodes to journal")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cb3acfb7dd1fc..dacbb999ae34d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -838,8 +838,10 @@ static int alloc_wbufs(struct ubifs_info *c)
 		c->jheads[i].wbuf.jhead = i;
 		c->jheads[i].grouped = 1;
 		c->jheads[i].log_hash = ubifs_hash_get_desc(c);
-		if (IS_ERR(c->jheads[i].log_hash))
+		if (IS_ERR(c->jheads[i].log_hash)) {
+			err = PTR_ERR(c->jheads[i].log_hash);
 			goto out;
+		}
 	}
 
 	/*
-- 
2.27.0



