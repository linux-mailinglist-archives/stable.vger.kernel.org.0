Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4B74095D2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346006AbhIMOpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347648AbhIMOmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D6261881;
        Mon, 13 Sep 2021 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541399;
        bh=ckLLooQf7jTadjrq98ecFDUZ+uE0cPivB1sU8x0Mvco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUhtmaaWimn7p6U7Lgjbf58K0zGVy/s17YFMy++p0qSaSN8MOnW/H9LNUpr/zcMER
         bZvQq6oh0kWzjQeF87i7oJ5mYgIAX6XQ0UEFHbByQcFm6Q3HQpbwc0dtyv46j5q77V
         Yut3PuYElhY+TNBZ//WUTqInkV+cbD+iQrNJonhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 283/334] brcmfmac: pcie: fix oops on failure to resume and reprobe
Date:   Mon, 13 Sep 2021 15:15:37 +0200
Message-Id: <20210913131122.994468724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit d745ca4f2c4ae9f1bd8cf7d8ac6e22d739bffd19 ]

When resuming from suspend, brcmf_pcie_pm_leave_D3 will first attempt a
hot resume and then fall back to removing the PCI device and then
reprobing. If this probe fails, the kernel will oops, because brcmf_err,
which is called to report the failure will dereference the stale bus
pointer. Open code and use the default bus-less brcmf_err to avoid this.

Fixes: 8602e62441ab ("brcmfmac: pass bus to the __brcmf_err() in pcie.c")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210817063521.22450-1-a.fatoum@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index c49dd0c36ae4..bbd72c2db088 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2075,7 +2075,7 @@ cleanup:
 
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
-		brcmf_err(bus, "probe after resume failed, err=%d\n", err);
+		__brcmf_err(NULL, __func__, "probe after resume failed, err=%d\n", err);
 
 	return err;
 }
-- 
2.30.2



