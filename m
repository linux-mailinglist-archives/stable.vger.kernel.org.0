Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE5127CDF
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfLTOax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfLTOax (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A45C824688;
        Fri, 20 Dec 2019 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852252;
        bh=0y5ItO9Q0Ez+Cf2qGWWe5Qs14+0yy6BbTXq6yhRnAIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCs7CQgDmQ429w7RM3mSGCOV8kXRhyJgXfTLbN+TjJJeCPeARKOhIG+5KnI0JaoJj
         ejMMTkf/MEFg9JDZDyg6YhK/lSk5gXsTzwM4azwFwztTLnlwMa/eBRFfn2OifpAgWd
         uQuzas2a7R4N8+LctUIW0bnAOTncs9ZHMadLjoMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/52] raid5: need to set STRIPE_HANDLE for batch head
Date:   Fri, 20 Dec 2019 09:29:45 -0500
Message-Id: <20191220142954.9500-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit a7ede3d16808b8f3915c8572d783530a82b2f027 ]

With commit 6ce220dd2f8ea71d6afc29b9a7524c12e39f374a ("raid5: don't set
STRIPE_HANDLE to stripe which is in batch list"), we don't want to set
STRIPE_HANDLE flag for sh which is already in batch list.

However, the stripe which is the head of batch list should set this flag,
otherwise panic could happen inside init_stripe at BUG_ON(sh->batch_head),
it is reproducible with raid5 on top of nvdimm devices per Xiao oberserved.

Thanks for Xiao's effort to verify the change.

Fixes: 6ce220dd2f8ea ("raid5: don't set STRIPE_HANDLE to stripe which is in batch list")
Reported-by: Xiao Ni <xni@redhat.com>
Tested-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 12a8ce83786ea..36cd7c2fbf408 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5726,7 +5726,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 				do_flush = false;
 			}
 
-			if (!sh->batch_head)
+			if (!sh->batch_head || sh == sh->batch_head)
 				set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if ((!sh->batch_head || sh == sh->batch_head) &&
-- 
2.20.1

