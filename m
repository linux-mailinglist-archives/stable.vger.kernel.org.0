Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C5E2E9AB1
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbhADQNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:13:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbhADP7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DFFC2251E;
        Mon,  4 Jan 2021 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775943;
        bh=HIyyo8liRqHsKYdvqDTiaA7kyReatdxKhUg7ukUFawA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0DzOtRvlZ03ViqOExNaWuzjNUmefd3oIlD0SGkQWtaEQLO7FmKLweY2sUiGyj5c+
         rtlmul7Nd1Bnz3Mi88u5V4MlOZcJUVcNtAf3jRunQyhKwrzSeTk9VsvBuQEuDKs7OY
         K/sqjIvaijJr6ow5zcXXw3BykYWQhukUlEg/LPd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeongseok Kim <hyeongseok@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/35] dm verity: skip verity work if I/O error when system is shutting down
Date:   Mon,  4 Jan 2021 16:57:38 +0100
Message-Id: <20210104155705.088824362@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



