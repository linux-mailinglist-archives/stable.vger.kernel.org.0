Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA07150DEC
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgBCQ0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBCQ0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:26:12 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8EC2080C;
        Mon,  3 Feb 2020 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747171;
        bh=DeCJmBu8rm1CIGpWKHCxQhQsPKt5JAnOYnxc4hK8Eqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMEPG538qkpTZBOpBGvxGJ0nqcBCfGAT1AciBtoSSJIs+ZLKU3HW5JH2rfoLE/Hi6
         MwrjoaeYgZ0mm95dm+M5T3sKmAKDKRryUJewT72/a/501gEmfkZ6mmbgBQtWbeeYoS
         bbDgacG5x45CsEXhCLhQyqbjgYByr6k9CTQHWe6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/68] usb: dwc3: turn off VBUS when leaving host mode
Date:   Mon,  3 Feb 2020 16:19:36 +0000
Message-Id: <20200203161911.590194611@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Liu <b-liu@ti.com>

[ Upstream commit 09ed259fac621634d51cd986aa8d65f035662658 ]

VBUS should be turned off when leaving the host mode.
Set GCTL_PRTCAP to device mode in teardown to de-assert DRVVBUS pin to
turn off VBUS power.

Fixes: 5f94adfeed97 ("usb: dwc3: core: refactor mode initialization to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 30bc5996a2f23..a89072f3bd3fb 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -936,6 +936,9 @@ static void dwc3_core_exit_mode(struct dwc3 *dwc)
 		/* do nothing */
 		break;
 	}
+
+	/* de-assert DRVVBUS for HOST and OTG mode */
+	dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
 }
 
 #define DWC3_ALIGN_MASK		(16 - 1)
-- 
2.20.1



