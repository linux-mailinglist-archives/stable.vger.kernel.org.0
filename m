Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C683F638A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhHXQ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233701AbhHXQ5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0A3613AB;
        Tue, 24 Aug 2021 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824177;
        bh=l3tXfFxjH3YDOLrwS73W639NpIt4rX6vnRziL3Pjj1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrepgJj47dX9G9wXc87nw4/BnHBPCtN1WTmeH5WUTApqmOuB6sFy+mBcwAdpSCq46
         XiXWfVZYSY6ZH4paS2YEyl0ohb+ujMeyHKqQ5Qcp8t7jWBdW8QQtCHSXOaJFHC9Zpi
         BYIhsxFljrvWw2pbyGzbM+ZDrc7yTjtKhmgxxJLWa6f9+KNquMqopTfdGlnUyxkurq
         L9GhfsxFnOfy7cik0CiJ/Ckyh1mGFCMhYZ1/tbXUtAMQKRevZ5J1j2hiKE4cK/IU8E
         WljOY3leUVGwEqVKDYtt8AoyXRNna7xKRHIcoJY/BqYAaNMvo6/ID/8tYSii4Jb+1w
         dvI3w1eg8S3ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 008/127] net: xfrm: Fix end of loop tests for list_for_each_entry
Date:   Tue, 24 Aug 2021 12:54:08 -0400
Message-Id: <20210824165607.709387-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

[ Upstream commit 480e93e12aa04d857f7cc2e6fcec181c0d690404 ]

The list_for_each_entry() iterator, "pos" in this code, can never be
NULL so the warning will never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_ipcomp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 2e8afe078d61..cb40ff0ff28d 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -241,7 +241,7 @@ static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 			break;
 	}
 
-	WARN_ON(!pos);
+	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
 
 	if (--pos->users)
 		return;
-- 
2.30.2

