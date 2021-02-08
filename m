Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8407313715
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhBHPTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:19:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhBHPNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D99A64EB4;
        Mon,  8 Feb 2021 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797007;
        bh=5nXurLHkhfRwdr0IL6csvaXjHO30CHpncxM/NEzjRRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqGCOZ5nFqlvUpXgo867plZ6zwydQ4MBxPGubyKL1z87ls6PFgSmdj+VHyML3IdWu
         RUB0HtyyuJlmErIyAxdgQ/kGEa/UfulO5S5lJVdqlKHcLOQDYM6S+8/GGgWeYxN8dp
         6QKqVuZHHy1wrv5cwbR1gnJq/UvHntbI0X/MfrwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gary Bisson <gary.bisson@boundarydevices.com>
Subject: [PATCH 5.4 27/65] usb: dwc3: fix clock issue during resume in OTG mode
Date:   Mon,  8 Feb 2021 16:00:59 +0100
Message-Id: <20210208145811.280508612@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary Bisson <gary.bisson@boundarydevices.com>

commit 0e5a3c8284a30f4c43fd81d7285528ece74563b5 upstream.

Commit fe8abf332b8f ("usb: dwc3: support clocks and resets for DWC3
core") introduced clock support and a new function named
dwc3_core_init_for_resume() which enables the clock before calling
dwc3_core_init() during resume as clocks get disabled during suspend.

Unfortunately in this commit the DWC3_GCTL_PRTCAP_OTG case was forgotten
and therefore during resume, a platform could call dwc3_core_init()
without re-enabling the clocks first, preventing to resume properly.

So update the resume path to call dwc3_core_init_for_resume() as it
should.

Fixes: fe8abf332b8f ("usb: dwc3: support clocks and resets for DWC3 core")
Cc: stable@vger.kernel.org
Signed-off-by: Gary Bisson <gary.bisson@boundarydevices.com>
Link: https://lore.kernel.org/r/20210125161934.527820-1-gary.bisson@boundarydevices.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1718,7 +1718,7 @@ static int dwc3_resume_common(struct dwc
 		if (PMSG_IS_AUTO(msg))
 			break;
 
-		ret = dwc3_core_init(dwc);
+		ret = dwc3_core_init_for_resume(dwc);
 		if (ret)
 			return ret;
 


