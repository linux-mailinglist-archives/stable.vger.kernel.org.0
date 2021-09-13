Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81373408DE0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbhIMNa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241415AbhIMNYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E738610D1;
        Mon, 13 Sep 2021 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539309;
        bh=jvto1BW8c4m+rCzIAmrjQpwTrZWMq1rifNIwG7vScDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST/bcLXouIBpzZSUBstbNkx+xeyBT0Hb7zNGcT0f4IZ2eZMtBb9xzqnUwP8qZR/jr
         Tr5tqJa8o4MiI06chxCvaY1NQRTKhTte046VZaPPngVagyfN7xQVeaFx/4REfSWqfz
         Etsl8MKs6XEkZ4EdJLziNrxNOEwuZiRC4L4Shjas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/144] brcmfmac: pcie: fix oops on failure to resume and reprobe
Date:   Mon, 13 Sep 2021 15:15:01 +0200
Message-Id: <20210913131051.937311398@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index bda042138e96..e6001f0a81a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2073,7 +2073,7 @@ cleanup:
 
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
-		brcmf_err(bus, "probe after resume failed, err=%d\n", err);
+		__brcmf_err(NULL, __func__, "probe after resume failed, err=%d\n", err);
 
 	return err;
 }
-- 
2.30.2



