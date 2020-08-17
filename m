Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B524715B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390530AbgHQSZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387633AbgHQQCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:02:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7686420748;
        Mon, 17 Aug 2020 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680158;
        bh=lKuZlK3cGDBnz/UmpJbdWU1Dq2Z9F6gf9uSTeiD+aeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnErmxzhPMp2CRl4IWjQP2CUqOx2JviUxTZ/tvcytRSlsoZ9NTUdwFTqYC3bNaBzq
         a3fcqKQNidAxlVg3nFF1HT3s6jDBGCky6aGobpoQB1LQlgVEtWWzXXB0djn+OEoP/o
         VQcaY9Cxw2GffEjv+5pR0i93Q6pwKXUQpQn7Tr1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/270] brcmfmac: keep SDIO watchdog running when console_interval is non-zero
Date:   Mon, 17 Aug 2020 17:14:36 +0200
Message-Id: <20200817143759.491435223@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index d43247a95ce53..38e6809f16c75 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3685,7 +3685,11 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
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



