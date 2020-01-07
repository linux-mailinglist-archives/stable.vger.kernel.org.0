Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E67C13314E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgAGU7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbgAGU7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB01D2081E;
        Tue,  7 Jan 2020 20:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430771;
        bh=FzjJ8LN2rCPoWlIp2O9xIYKGOaQu9uhodc1hUT0rN4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jb8N91hZn2mu602+g4VXV2c5Ts/fA23XkCdQTAI9wJeOWPVuqCZErr3A51pNSF3a/
         u1B1vZvrt4Wyda7JY6477iDK0UOD+086cTCYdxsBDLTgLThycwUOOqFzm1nuZXF2uL
         P5UELnISh+LzwYmJT/uwSZQhrM9G8jK+5NeS9a4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/191] raid5: need to set STRIPE_HANDLE for batch head
Date:   Tue,  7 Jan 2020 21:52:43 +0100
Message-Id: <20200107205335.298040834@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 12a8ce83786e..36cd7c2fbf40 100644
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



