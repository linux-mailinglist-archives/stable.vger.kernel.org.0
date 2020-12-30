Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFF2E7932
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgL3NHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgL3NF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E00922A83;
        Wed, 30 Dec 2020 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333475;
        bh=HIyyo8liRqHsKYdvqDTiaA7kyReatdxKhUg7ukUFawA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8yZ28ncE/AHeEtBgwUKvjg/wdMoslc4R6g9g4fSkD0ynIawrAul61e0Gn7Omvs2s
         3Y2FMNpa+qtVcL8Jq/2b+ljhX4RT4YeuWvRoGfEo+6vsz+zVtOYjL34byI9C2wthKK
         lWihjh8wEkmc8xQ2GC+aTo6CTzpVpTC8LEdkRRkkOurl6uixb+Z9LEfS/tbEtcxVQG
         armaQQUHnp5TiCpnHeGnWTryUyg8I+LItGl0M2cMSnQrNDQc6m4aFwEHDV1vohzFcM
         5eTB3hvfISiAn6cz5l+EHFjX8eA3sKEHukI+vo/j3aPicwQo5cgLBIRo/pB6vd7PyA
         5dHGAfBpottSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyeongseok Kim <hyeongseok@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 10/10] dm verity: skip verity work if I/O error when system is shutting down
Date:   Wed, 30 Dec 2020 08:04:22 -0500
Message-Id: <20201230130422.3637448-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130422.3637448-1-sashal@kernel.org>
References: <20201230130422.3637448-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeongseok Kim <hyeongseok@gmail.com>

[ Upstream commit 252bd1256396cebc6fc3526127fdb0b317601318 ]

If emergency system shutdown is called, like by thermal shutdown,
a dm device could be alive when the block device couldn't process
I/O requests anymore. In this state, the handling of I/O errors
by new dm I/O requests or by those already in-flight can lead to
a verity corruption state, which is a misjudgment.

So, skip verity work in response to I/O error when system is shutting
down.

Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-target.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index e3599b43f9eb9..599be2d2b0ae9 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -533,6 +533,15 @@ static int verity_verify_io(struct dm_verity_io *io)
 	return 0;
 }
 
+/*
+ * Skip verity work in response to I/O error when system is shutting down.
+ */
+static inline bool verity_is_system_shutting_down(void)
+{
+	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
+		|| system_state == SYSTEM_RESTART;
+}
+
 /*
  * End one "io" structure with a given error.
  */
@@ -560,7 +569,8 @@ static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
 
-	if (bio->bi_status && !verity_fec_is_enabled(io->v)) {
+	if (bio->bi_status &&
+	    (!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
 		verity_finish_io(io, bio->bi_status);
 		return;
 	}
-- 
2.27.0

