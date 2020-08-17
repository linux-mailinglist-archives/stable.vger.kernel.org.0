Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931B52469C1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbgHQPZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgHQPZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ADB523A62;
        Mon, 17 Aug 2020 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677927;
        bh=tUwrDxtVL/bbLaD1/XzbswHRTKnAjV1eEqHFMCjxayk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIID9OA8iXMgKKQ8zjBk81htwWf7MpFN6DsA9vEpziZ8OCI+61pkJ6PtJIQ8yLna3
         4+Io+giOKmPqWq1kY0iClpTCzjTGV/MSXBwRbse/9zcQovHewTIrNqgYEmXq4xkImz
         VBEgEPI44zU56SBUNCeLThEIQtWtJKGuztLoPcuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 118/464] brcmfmac: keep SDIO watchdog running when console_interval is non-zero
Date:   Mon, 17 Aug 2020 17:11:11 +0200
Message-Id: <20200817143839.464301090@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit eccbf46b15bb3e35d004148f7c3a8fa8e9b26c1e ]

brcmfmac host driver makes SDIO bus sleep and stops SDIO watchdog if no
pending event or data. As a result, host driver does not poll firmware
console buffer before buffer overflow, which leads to missing firmware
logs. We should not stop SDIO watchdog if console_interval is non-zero
in debug build.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200604071835.3842-4-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 310d8075f5d71..bc02168ebb536 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3699,7 +3699,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 			if (bus->idlecount > bus->idletime) {
 				brcmf_dbg(SDIO, "idle\n");
 				sdio_claim_host(bus->sdiodev->func1);
-				brcmf_sdio_wd_timer(bus, false);
+#ifdef DEBUG
+				if (!BRCMF_FWCON_ON() ||
+				    bus->console_interval == 0)
+#endif
+					brcmf_sdio_wd_timer(bus, false);
 				bus->idlecount = 0;
 				brcmf_sdio_bus_sleep(bus, true, false);
 				sdio_release_host(bus->sdiodev->func1);
-- 
2.25.1



