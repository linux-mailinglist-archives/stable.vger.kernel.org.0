Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8234418B8
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhKAJuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234731AbhKAJss (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21E9A6117A;
        Mon,  1 Nov 2021 09:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759080;
        bh=neNbb1lS9mPDKJJTeoCw3hvhNrfP6N74eu6k6XZsfNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfkmfHZu956Qf3etTizVZfGwTZlemKapYA7empkh+PVg77h0xV/EM3NYwRtnj4q45
         XMudmcdjNjILRYxQCMxSvuM9KuUa5JWzqUfOcVqPhr5itjY+4YaAV805uPY2lAdOQ+
         3kM+kA/ng77ZQc63ppVfmba8/X1S7+zizZh9NLoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.14 074/125] reset: brcmstb-rescal: fix incorrect polarity of status bit
Date:   Mon,  1 Nov 2021 10:17:27 +0100
Message-Id: <20211101082547.226921183@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <jim2101024@gmail.com>

commit f33eb7f29c16ba78db3221ee02346fd832274cdd upstream.

The readl_poll_timeout() should complete when the status bit
is a 1, not 0.

Fixes: 4cf176e52397 ("reset: Add Broadcom STB RESCAL reset controller")
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210914221122.62315-1-f.fainelli@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-brcmstb-rescal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/reset/reset-brcmstb-rescal.c
+++ b/drivers/reset/reset-brcmstb-rescal.c
@@ -38,7 +38,7 @@ static int brcm_rescal_reset_set(struct
 	}
 
 	ret = readl_poll_timeout(base + BRCM_RESCAL_STATUS, reg,
-				 !(reg & BRCM_RESCAL_STATUS_BIT), 100, 1000);
+				 (reg & BRCM_RESCAL_STATUS_BIT), 100, 1000);
 	if (ret) {
 		dev_err(data->dev, "time out on SATA/PCIe rescal\n");
 		return ret;


