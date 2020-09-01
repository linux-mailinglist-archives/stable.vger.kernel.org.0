Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFC9259477
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgIAPkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbgIAPkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4319A20866;
        Tue,  1 Sep 2020 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974800;
        bh=+E4hKw1KlotMgdPsh85OOc8gIiNZmD4sgzl+PG/oqFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4u+3MTYg6wedwKdcSm9CF0F6OXBk3Db3+uryC/z8STcnQtv0njHaCS4hympOe094
         oVdXqE8pFggSR+GCv/7gX8R43e7DQ8v8/3F+511zZcAKwtlefcFGNxknKHqkXPNbA+
         73gCiqTw/V5Nlu/MJZXDZ8v819brzMpbWeTbwO9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Martin George <marting@netapp.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 096/255] nvme: multipath: round-robin: fix single non-optimized path case
Date:   Tue,  1 Sep 2020 17:09:12 +0200
Message-Id: <20200901151005.324359109@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 93eb0381e13d249a18ed4aae203291ff977e7ffb ]

If there's only one usable, non-optimized path, nvme_round_robin_path()
returns NULL, which is wrong. Fix it by falling back to "old", like in
the single optimized path case. Also, if the active path isn't changed,
there's no need to re-assign the pointer.

Fixes: 3f6e3246db0e ("nvme-multipath: fix logic for non-optimized paths")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin George <marting@netapp.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 2672953233434..041a755f936a6 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -255,12 +255,17 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head,
 			fallback = ns;
 	}
 
-	/* No optimized path found, re-check the current path */
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
 	if (!nvme_path_is_disabled(old) &&
-	    old->ana_state == NVME_ANA_OPTIMIZED) {
-		found = old;
-		goto out;
-	}
+	    (old->ana_state == NVME_ANA_OPTIMIZED ||
+	     (!fallback && old->ana_state == NVME_ANA_NONOPTIMIZED)))
+		return old;
+
 	if (!fallback)
 		return NULL;
 	found = fallback;
-- 
2.25.1



