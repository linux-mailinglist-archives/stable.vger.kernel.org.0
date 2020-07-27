Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AE522EFF5
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbgG0OUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729871AbgG0OUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C9612070A;
        Mon, 27 Jul 2020 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859641;
        bh=8fQOmzrojSKWlqJUC3E5/6JDT7PIiYuRQoMXQLibL04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0jryEQyh/MytZu/BbWpMsA1hAFLw2D62oDg+07O9MZJ+sEfdwuvfoYVCSEE+yxr6
         WcTZLBNzOx5yys002chrT1NlIT5umHvvZZmtbmPP1XOt2Cdao92YPAyYTByKdTKOXS
         +AVGhH5t5Pf2TdFk1UHs72Jona+yakLtH2ZgJCG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        Xu Yilun <yilun.xu@intel.com>, Wu Hao <hao.wu@intel.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 047/179] fpga: dfl: fix bug in port reset handshake
Date:   Mon, 27 Jul 2020 16:03:42 +0200
Message-Id: <20200727134934.958840022@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Gerlach <matthew.gerlach@linux.intel.com>

[ Upstream commit 8614afd689df59d9ce019439389be20bd788a897 ]

When putting the port in reset, driver must wait for the soft reset
acknowledgment bit instead of the soft reset bit.

Fixes: 47c1b19c160f (fpga: dfl: afu: add port ops support)
Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl-afu-main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
index 65437b6a68424..77e257c88a1df 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -83,7 +83,8 @@ int __afu_port_disable(struct platform_device *pdev)
 	 * on this port and minimum soft reset pulse width has elapsed.
 	 * Driver polls port_soft_reset_ack to determine if reset done by HW.
 	 */
-	if (readq_poll_timeout(base + PORT_HDR_CTRL, v, v & PORT_CTRL_SFTRST,
+	if (readq_poll_timeout(base + PORT_HDR_CTRL, v,
+			       v & PORT_CTRL_SFTRST_ACK,
 			       RST_POLL_INVL, RST_POLL_TIMEOUT)) {
 		dev_err(&pdev->dev, "timeout, fail to reset device\n");
 		return -ETIMEDOUT;
-- 
2.25.1



