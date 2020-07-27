Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD9E22EEB3
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgG0OKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729743AbgG0OJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:09:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E5B720838;
        Mon, 27 Jul 2020 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858997;
        bh=KZrWMhpETOvjPpLc1CgHzf86C/y6r++ck0qVo8CAzxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0l19B0RP127R6ZSN+BnyaVPpqHX79n2hgIKL6pBeuun1HPz+PG6zHfT3Gs1DC4SJw
         eeNuPjOPqMSjzA6V/PZsFkN/qzKt/Nu+27u9+Oc9mfSTBSa/2vMaCBcssBw2AWHE9a
         S0cmyUoMvakh/ELsX6TC3PkbQnGWRX8+XY17bpQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        Xu Yilun <yilun.xu@intel.com>, Wu Hao <hao.wu@intel.com>,
        Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/86] fpga: dfl: fix bug in port reset handshake
Date:   Mon, 27 Jul 2020 16:04:00 +0200
Message-Id: <20200727134915.766651196@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
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
index 02baa6a227c0c..fc048f9a99b19 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -79,7 +79,8 @@ static int port_disable(struct platform_device *pdev)
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



