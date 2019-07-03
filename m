Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5F45DB9F
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfGCCQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbfGCCQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCDED2189F;
        Wed,  3 Jul 2019 02:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120208;
        bh=WkK+kTJashnT0bWWbMgBLKOFuKWDJnwHFusuOvM2TY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+mli7inG/KJsLCzQ6Dbzk5PX50IVXyEVA1h6OekE3W/vTt1M1znfEs/moCWg68Fj
         7R0zXmwpqQ1L3/+zdkpIqTPmsBWBSgXjXCxkQtycIDX8+nP0eDX4oH1j89SZgWVGy5
         kbTx0dEhDjgGlAuReWnrCE5Pcb+Vpfvfq18NKyns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 18/26] dm verity: use message limit for data block corruption message
Date:   Tue,  2 Jul 2019 22:16:17 -0400
Message-Id: <20190703021625.18116-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milan Broz <gmazyland@gmail.com>

[ Upstream commit 2eba4e640b2c4161e31ae20090a53ee02a518657 ]

DM verity should also use DMERR_LIMIT to limit repeat data block
corruption messages.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index fc65f0dedf7f..e3599b43f9eb 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -236,8 +236,8 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 		BUG();
 	}
 
-	DMERR("%s: %s block %llu is corrupted", v->data_dev->name, type_str,
-		block);
+	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
+		    type_str, block);
 
 	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
 		DMERR("%s: reached maximum errors", v->data_dev->name);
-- 
2.20.1

