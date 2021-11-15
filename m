Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA143451E05
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346002AbhKPAeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344443AbhKOTYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AF3663679;
        Mon, 15 Nov 2021 18:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002670;
        bh=dEGP4LITW/muASRlsEeWsHD5e9oeK2uLVaypXlduXBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmNAfoEgQFXKgQ+JdbEuWYr6HHOmbKrfmldw3rKqC7fDR/rQSVXeTvT+lC3Tv1rkk
         sov0d1IAGyJh9XDrCCulevpoUKMB4C2xCmXqy5sNUry1iM1t3l529stnJS42K1djmS
         WPQ+dWxwl4RXgYCPO+DX8e1TMHCJ4Y8ErdWIM9s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 654/917] usb: dwc2: drd: reset current session before setting the new one
Date:   Mon, 15 Nov 2021 18:02:29 +0100
Message-Id: <20211115165451.048484682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 1ad707f559f7cb12c64f3d7cb37f0b1ea27c1058 ]

If role is changed without the "none" step, A- and B- valid session could
be set at the same time. It is an issue.
This patch resets A-session if role switch sets B-session, and resets
B-session if role switch sets A-session.
Then, it is possible to change the role without the "none" step.

Fixes: 17f934024e84 ("usb: dwc2: override PHY input signals with usb role switch support")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211005095305.66397-4-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/drd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc2/drd.c b/drivers/usb/dwc2/drd.c
index 99672360f34b0..aa6eb76f64ddc 100644
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -40,6 +40,7 @@ static int dwc2_ovr_avalid(struct dwc2_hsotg *hsotg, bool valid)
 	    (!valid && !(gotgctl & GOTGCTL_ASESVLD)))
 		return -EALREADY;
 
+	gotgctl &= ~GOTGCTL_BVALOVAL;
 	if (valid)
 		gotgctl |= GOTGCTL_AVALOVAL | GOTGCTL_VBVALOVAL;
 	else
@@ -58,6 +59,7 @@ static int dwc2_ovr_bvalid(struct dwc2_hsotg *hsotg, bool valid)
 	    (!valid && !(gotgctl & GOTGCTL_BSESVLD)))
 		return -EALREADY;
 
+	gotgctl &= ~GOTGCTL_AVALOVAL;
 	if (valid)
 		gotgctl |= GOTGCTL_BVALOVAL | GOTGCTL_VBVALOVAL;
 	else
-- 
2.33.0



