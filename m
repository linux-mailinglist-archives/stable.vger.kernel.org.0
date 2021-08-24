Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ED33F64B2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbhHXRGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239636AbhHXREb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84976141B;
        Tue, 24 Aug 2021 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824369;
        bh=iD9D/k5aNOEcdSZegmyuiigYvh4NINWH+mB9toJlgiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YV9YvjIAywGKokGIA121x1NCOWo6rvopUmDXxtazc3KfIU9NiswawowSbXxsTnBsN
         xmlB9S/oUq+tlhy7sM2yEYCWmdclg2cHtWg7xnEi3EjpAVHw+jlaLbSPX7kvHCOd2x
         +mfze9u3u37sQtsO+b5B49LV+dLHhlz1S33/FY1jZxAOn+riV+l6yKvmJjspY0ZQ6i
         G1S3im4cYCjovIqtjcZoKXxdFJUQaEQqHvg/layegIqr/8BQQVsvmz0BJkxDpagNz+
         W2EVtJkoSozhPFsRbzx/29c9UCvIeFNISgeYMGJPL0PqxAGMaMgiXvopocHdp3YMxD
         vxM+94WdU3gcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/98] net: xfrm: Fix end of loop tests for list_for_each_entry
Date:   Tue, 24 Aug 2021 12:57:49 -0400
Message-Id: <20210824165908.709932-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 4d422447aadc..0814320472f1 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -250,7 +250,7 @@ static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 			break;
 	}
 
-	WARN_ON(!pos);
+	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
 
 	if (--pos->users)
 		return;
-- 
2.30.2

