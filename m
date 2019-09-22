Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108EBBAA78
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfIVT0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405900AbfIVSvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35E2721A4A;
        Sun, 22 Sep 2019 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178299;
        bh=vXDkuYne+Hy4F82vAvYwB/USPCaWPvacv5O9Bg8gQqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0+ogpOWdDp+Ksp+/KgMQBzEA+LzODEuwYoO45A7+mxRndd6Bk8YVh5d2RUC21QiG
         ZMuecKxGoLq0ibBKhXH/BaHd2IMrkvHB7zBdddtsVx4TwnuxAg+IR9jlcSrpVGhX+B
         iMkV+O7BsyO1ugUoUmKv/zEiWAMqE6kbgqGjoqg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 073/185] media: vsp1: fix memory leak of dl on error return path
Date:   Sun, 22 Sep 2019 14:47:31 -0400
Message-Id: <20190922184924.32534-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 70c55c1ad1a76e804ee5330e134674f5d2741cb7 ]

Currently when the call vsp1_dl_body_get fails and returns null the
error return path leaks the allocation of dl. Fix this by kfree'ing
dl before returning.

Addresses-Coverity: ("Resource leak")

Fixes: 5d7936b8e27d ("media: vsp1: Convert display lists to use new body pool")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 104b6f5145364..d7b43037e500a 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -557,8 +557,10 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 
 	/* Get a default body for our list. */
 	dl->body0 = vsp1_dl_body_get(dlm->pool);
-	if (!dl->body0)
+	if (!dl->body0) {
+		kfree(dl);
 		return NULL;
+	}
 
 	header_offset = dl->body0->max_entries * sizeof(*dl->body0->entries);
 
-- 
2.20.1

