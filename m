Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B825DBDA
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfGCCTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728399AbfGCCTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:19:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287152187F;
        Wed,  3 Jul 2019 02:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120346;
        bh=3LGD3ZXA9YNPb1KDPwEDA616er0ij4of3wGQGGwwqjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6ElJd4As6Nd0GVWFpmcYXn2jUJ4LVVYoK5pQ+JeU3Q/PJpkn9+rBJ/1UCrmfVFPy
         pcja97+JTAASHhiiBnXovwyrsO4wTaNOVnqwyet714DdgE3kchxFQkA/ZtLDr/kTGh
         xSCNe22vpd7L6iQrkWp5AdsfWvV955eplwtpkGCI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 6/6] dm verity: use message limit for data block corruption message
Date:   Tue,  2 Jul 2019 22:18:58 -0400
Message-Id: <20190703021858.18653-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021858.18653-1-sashal@kernel.org>
References: <20190703021858.18653-1-sashal@kernel.org>
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
 drivers/md/dm-verity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index ccf41886ebcf..7054afd49f82 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -221,8 +221,8 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
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

