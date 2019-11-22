Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8A5106E23
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfKVLG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731865AbfKVLG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917AF2075E;
        Fri, 22 Nov 2019 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420788;
        bh=PoHu/DhS+f5VCbwNRPxqlH6ZIVZ4cG59h9sqHS6KGpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUB/Nm68KOLfk2JGB1OTrs8eDwssgaiG5BMTaqdXFxsFIWF98x5xyAwVXrKTwVWKe
         5YRuXXwK43zpKRvZOglcboPIRBMbkMwhBSBSCisFtDClejIQTbP2fEp2oirvU+Wcvj
         vGjRz9O8iY9MbOjF9kC7lBt48FjVp/+5I4yP/2tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Saito <takeshi.saito.xv@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/220] mmc: tmio: fix SCC error handling to avoid false positive CRC error
Date:   Fri, 22 Nov 2019 11:29:44 +0100
Message-Id: <20191122100929.359156615@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 94c43c3d3ae58..35630ccbe9e5d 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -926,8 +926,9 @@ static void tmio_mmc_finish_request(struct tmio_mmc_host *host)
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



