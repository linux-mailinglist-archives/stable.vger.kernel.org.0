Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C11B150CE5
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbgBCQgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgBCQgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:40 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 263EB2087E;
        Mon,  3 Feb 2020 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747799;
        bh=zq1mM+BQtoXxabfk7Zvlh7qUAaowYSCbfMa5RRK5uS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHFPvD1jW6cMgh3/6Jg/C6DTwXqsJ3zuBHDmX6hIFnkp/d6FlcJOhi+cirDZJLz5k
         N1+YYjF1IgTyTwcv/hD0etMzR1VWF+hPW8WzZtWMOhfXnsCNNHrzGKJxbeSR0Nqg8i
         yHydys+qzFmYwzvv6ktFhMElAGLfpDPgL/ex0TDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 76/90] r8152: disable U2P3 for RTL8153B
Date:   Mon,  3 Feb 2020 16:20:19 +0000
Message-Id: <20200203161926.561975576@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 809a7fc6593f288d6f820ef6cc57b9d69b5f9474 ]

Enable U2P3 may miss zero packet for bulk-in.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index df993a1c60c0e..debab2c27f638 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3175,7 +3175,6 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 		r8153b_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
-		r8153_u2p3en(tp, true);
 		r8153b_u1u2en(tp, true);
 	}
 }
@@ -3703,7 +3702,6 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 
 	r8153_aldps_en(tp, true);
 	r8152b_enable_fc(tp);
-	r8153_u2p3en(tp, true);
 
 	set_bit(PHY_RESET, &tp->flags);
 }
@@ -4055,7 +4053,6 @@ static void rtl8153b_up(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
 
 	r8153_aldps_en(tp, true);
-	r8153_u2p3en(tp, true);
 	r8153b_u1u2en(tp, true);
 }
 
-- 
2.20.1



