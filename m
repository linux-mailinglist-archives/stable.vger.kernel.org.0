Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829AEFA4DF
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfKMBzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbfKMBzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D75E1204EC;
        Wed, 13 Nov 2019 01:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610114;
        bh=m+qnqZ/ShNKNjyAacelus/FWNvJ3XrIxXhEmoCmrUqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+e9yssiEYnxhV3kdElLVgJepNY2+BAaF/J5vZzIbvey3vbfA71Ru0ldA0zSM1RWQ
         9KDumg4H1Px3qvrXuMvEkRv4u2H6TZAVudhV6jFm0M7OL1mD8gPdNr/iOJl1bmHIzt
         ncojSaGNqfka+fFUaJ6gDV4Pq+X7TPQk3JFnNDEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@cnexlabs.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 170/209] lightnvm: pblk: guarantee emeta on line close
Date:   Tue, 12 Nov 2019 20:49:46 -0500
Message-Id: <20191113015025.9685-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier González <javier@javigon.com>

[ Upstream commit 9cc85bc761f83da41935cdd6edcdb7c122bc90bf ]

If a line is recovered from open chunks, the memory structures for
emeta have not necessarily been properly set on line initialization.
When closing a line, make sure that emeta is consistent so that the line
can be recovered on the fast path on next reboot.

Also, remove a couple of empty lines at the end of the function.

Signed-off-by: Javier González <javier@cnexlabs.com>
Signed-off-by: Matias Bjørling <mb@lightnvm.io>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/lightnvm/pblk-core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/lightnvm/pblk-core.c b/drivers/lightnvm/pblk-core.c
index fd322565fb0f9..8dce31dbf2cbc 100644
--- a/drivers/lightnvm/pblk-core.c
+++ b/drivers/lightnvm/pblk-core.c
@@ -1773,6 +1773,17 @@ void pblk_line_close_meta(struct pblk *pblk, struct pblk_line *line)
 	wa->pad = cpu_to_le64(atomic64_read(&pblk->pad_wa));
 	wa->gc = cpu_to_le64(atomic64_read(&pblk->gc_wa));
 
+	if (le32_to_cpu(emeta_buf->header.identifier) != PBLK_MAGIC) {
+		emeta_buf->header.identifier = cpu_to_le32(PBLK_MAGIC);
+		memcpy(emeta_buf->header.uuid, pblk->instance_uuid, 16);
+		emeta_buf->header.id = cpu_to_le32(line->id);
+		emeta_buf->header.type = cpu_to_le16(line->type);
+		emeta_buf->header.version_major = EMETA_VERSION_MAJOR;
+		emeta_buf->header.version_minor = EMETA_VERSION_MINOR;
+		emeta_buf->header.crc = cpu_to_le32(
+			pblk_calc_meta_header_crc(pblk, &emeta_buf->header));
+	}
+
 	emeta_buf->nr_valid_lbas = cpu_to_le64(line->nr_valid_lbas);
 	emeta_buf->crc = cpu_to_le32(pblk_calc_emeta_crc(pblk, emeta_buf));
 
@@ -1790,8 +1801,6 @@ void pblk_line_close_meta(struct pblk *pblk, struct pblk_line *line)
 	spin_unlock(&l_mg->close_lock);
 
 	pblk_line_should_sync_meta(pblk);
-
-
 }
 
 static void pblk_save_lba_list(struct pblk *pblk, struct pblk_line *line)
-- 
2.20.1

