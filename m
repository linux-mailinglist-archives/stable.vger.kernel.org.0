Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD18C29BA40
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796380AbgJ0P6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804033AbgJ0Pxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B6A20829;
        Tue, 27 Oct 2020 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814019;
        bh=mTY9y3pxS8i08iT2C0dGcNyVykiKc/+2kfaNjS4clTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8qoUQ8z+e+pmUqu9LIhWsAwE/5qeO4QsW2W7ZIct5ujHesRDkxraIE0lYbcdCcnG
         SJodaVyuUHTdFrNZpTZtg59MtK7nmADduHIqn1fTKMcLzKrPC7GHmMmpXndRh9cgSZ
         FgAaZLOl5q+ZF4fWnE1okqEfxnwroIfn8DE7QPuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 717/757] brcmsmac: fix memory leak in wlc_phy_attach_lcnphy
Date:   Tue, 27 Oct 2020 14:56:07 +0100
Message-Id: <20201027135524.136611679@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit f4443293d741d1776b86ed1dd8c4e4285d0775fc ]

When wlc_phy_txpwr_srom_read_lcnphy fails in wlc_phy_attach_lcnphy,
the allocated pi->u.pi_lcnphy is leaked, since struct brcms_phy will be
freed in the caller function.

Fix this by calling wlc_phy_detach_lcnphy in the error handler of
wlc_phy_txpwr_srom_read_lcnphy before returning.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200908121743.23108-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index 7ef36234a25dc..66797dc5e90d5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -5065,8 +5065,10 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	pi->pi_fptr.radioloftget = wlc_lcnphy_get_radio_loft;
 	pi->pi_fptr.detach = wlc_phy_detach_lcnphy;
 
-	if (!wlc_phy_txpwr_srom_read_lcnphy(pi))
+	if (!wlc_phy_txpwr_srom_read_lcnphy(pi)) {
+		kfree(pi->u.pi_lcnphy);
 		return false;
+	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
 		if (pi_lcn->lcnphy_tempsense_option == 3) {
-- 
2.25.1



