Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED30106F3B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfKVKxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbfKVKxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6647B20718;
        Fri, 22 Nov 2019 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420017;
        bh=UG/trRbmRpxl3vtMnIFWUwEZ1MwIeNkNhQGy5Vhy+B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wREesQ1EAese8wEd/48XLJbRW8rdO1+1xvLT/j9JORpdW99n2fxNb/F2xiTD3fE4Y
         QmfoDe4zcGvkiEOPXUg+DiMM+S3DjMeorUr8ogq4SEAUwb+qRwZqeqlA8FlBZr9rzD
         45sJfROpIc8vPoRUfXI3348v0pCixGiewJzoGUyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masaharu Hayakawa <masaharu.hayakawa.ry@renesas.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/122] mmc: tmio: Fix SCC error detection
Date:   Fri, 22 Nov 2019 11:29:01 +0100
Message-Id: <20191122100826.861772275@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masaharu Hayakawa <masaharu.hayakawa.ry@renesas.com>

[ Upstream commit b85fb0a1c8aeaaa40d08945d51a6656b512173f0 ]

SDR104, HS200 and HS400 need to check for SCC error. If SCC error is
detected, retuning is necessary.

Signed-off-by: Masaharu Hayakawa <masaharu.hayakawa.ry@renesas.com>
[Niklas: update commit message]
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index 2437fcde915a7..01e51b7945750 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -914,8 +914,8 @@ static void tmio_mmc_finish_request(struct tmio_mmc_host *host)
 	if (mrq->cmd->error || (mrq->data && mrq->data->error))
 		tmio_mmc_abort_dma(host);
 
-	if (host->check_scc_error)
-		host->check_scc_error(host);
+	if (host->check_scc_error && host->check_scc_error(host))
+		mrq->cmd->error = -EILSEQ;
 
 	/* If SET_BLOCK_COUNT, continue with main command */
 	if (host->mrq && !mrq->cmd->error) {
-- 
2.20.1



