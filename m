Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E668D3CD823
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242272AbhGSOUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242340AbhGSOTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:19:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B777661073;
        Mon, 19 Jul 2021 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706785;
        bh=zGOVYjwyMffJLWfigNL2olJxhT7aPhNmZaFHOVgs7cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmNgUw5Z/FKZ9ln8Nh7bP5ImVrsU6ToGlqQMDpkjW8fNzQdaO/HLpab4fp3h8cRog
         ZekqYRMbp7GNi9V/F1L56hRhEQ1eq8qHuCW8kq/QNYRxS3grL//OTo+/n7V8QnBrKE
         oJ/AQ7PeHqoKK3tmZBqiSXs1jNBaGkFUUJFgMgtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 097/188] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Mon, 19 Jul 2021 16:51:21 +0200
Message-Id: <20210719144935.739756396@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 009fc857c5f6fda81f2f7dd851b2d54193a8e733 ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index ff48da61c94c..89cf1d695a01 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2352,7 +2352,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2



