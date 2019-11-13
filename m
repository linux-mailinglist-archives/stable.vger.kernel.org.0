Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4F9FA1CB
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfKMB7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbfKMB72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6666122469;
        Wed, 13 Nov 2019 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610367;
        bh=xfiRYlBrrR42DVKHJwACyiYlj/Argp6WATZos1+CRlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+Mc0UzHtkrMBAn6c3Jv7PHDT6WfiU0tsSI06/y2lXTP/7tWbpkuWrz2EaVH/bQBU
         PzCrKmtDoIvdR5qC546T0k8atJXspieH2OYIo4wBnQYmIZpDq29aOtfN0T86U52f04
         6ojYvJvVAsvYPl6LONg9vF0cp96Ty85H7AkY6Eic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 115/115] mmc: tmio: fix SCC error handling to avoid false positive CRC error
Date:   Tue, 12 Nov 2019 20:56:22 -0500
Message-Id: <20191113015622.11592-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Saito <takeshi.saito.xv@renesas.com>

[ Upstream commit 51b72656bb39fdcb8f3174f4007bcc83ad1d275f ]

If an SCC error occurs during a read/write command execution, a false
positive CRC error message is output.

mmcblk0: response CRC error sending r/w cmd command, card status 0x900

check_scc_error() checks SCC_RVSREQ.RVSERR bit. RVSERR detects a
correction error in the next (up or down) delay tap position. However,
since the command is successful, only retuning needs to be executed.
This has been confirmed by HW engineers.

Thus, on SCC error, set retuning flag instead of setting an error code.

Fixes: b85fb0a1c8ae ("mmc: tmio: Fix SCC error detection")
Signed-off-by: Takeshi Saito <takeshi.saito.xv@renesas.com>
[wsa: updated comment and commit message, removed some braces]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index 01e51b7945750..2fd862dc97701 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -914,8 +914,9 @@ static void tmio_mmc_finish_request(struct tmio_mmc_host *host)
 	if (mrq->cmd->error || (mrq->data && mrq->data->error))
 		tmio_mmc_abort_dma(host);
 
+	/* SCC error means retune, but executed command was still successful */
 	if (host->check_scc_error && host->check_scc_error(host))
-		mrq->cmd->error = -EILSEQ;
+		mmc_retune_needed(host->mmc);
 
 	/* If SET_BLOCK_COUNT, continue with main command */
 	if (host->mrq && !mrq->cmd->error) {
-- 
2.20.1

