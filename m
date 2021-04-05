Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BD5353DB3
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhDEJCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237256AbhDEJB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0EED61393;
        Mon,  5 Apr 2021 09:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613273;
        bh=gXfGryz/rT1sV6iFcfi3sOZixW/3jHTCFMDGSY4KC8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqPLnmTHac41Zl2TieVKRLsYrdjP0gpY+oqQQY6jIHFSgC7hw4PLmb+yaQEtExoBn
         1lkJykZmhY6HjZv59KVHzvo+wabOtO4eeeyU7GBBYyCgphqT23S1hffOeN+zfK8ShC
         xATmEPHgPtzXehUA4bQDxOZlZqhLGZ4LcGXQTzvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/56] net: ethernet: aquantia: Handle error cleanup of start on open
Date:   Mon,  5 Apr 2021 10:53:56 +0200
Message-Id: <20210405085023.346009073@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit 8a28af7a3e85ddf358f8c41e401a33002f7a9587 ]

The aq_nic_start function can fail in a variety of cases which leaves
the device in broken state.

An example case where the start function fails is the
request_threaded_irq which can be interrupted, resulting in a EINTR
result. This can be manually triggered by bringing the link up (e.g. ip
link set up) and triggering a SIGINT on the initiating process (e.g.
Ctrl+C). This would put the device into a half configured state.
Subsequently bringing the link up again would cause the napi_enable to
BUG.

In order to correctly clean up the failed attempt to start a device call
aq_nic_stop.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e3ae29e523f0..daf841ae337d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -50,8 +50,10 @@ static int aq_ndev_open(struct net_device *ndev)
 	if (err < 0)
 		goto err_exit;
 	err = aq_nic_start(aq_nic);
-	if (err < 0)
+	if (err < 0) {
+		aq_nic_stop(aq_nic);
 		goto err_exit;
+	}
 
 err_exit:
 	if (err < 0)
-- 
2.30.1



