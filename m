Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913EB3A6291
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhFNLBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235135AbhFNLAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B07C061436;
        Mon, 14 Jun 2021 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667364;
        bh=FNHdvV5gRfdkfTmM6T5k/QAZ8L1tj0CITsaPmdGBSVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPI19vPNA556nMluWv3ZVyXxYPR45DuTtdbPFQPAQK00dL56IEy6jybzqudWdvMzs
         1lZGT5P2Et8F2gINfopbNJ23sapCbRpyvrg29qbao5J5uqQqqgCE2ixzWvi8PAs4iR
         +9k4ikpbtxN7ufWb3xD/DSvXbHU265bU3RLBp3xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/131] usb: cdns3: Fix runtime PM imbalance on error
Date:   Mon, 14 Jun 2021 12:26:09 +0200
Message-Id: <20210614102653.259267236@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 07adc0225484fc199e3dc15ec889f75f498c4fca ]

When cdns3_gadget_start() fails, a pairing PM usage counter
decrement is needed to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20210412054908.7975-1-dinghao.liu@zju.edu.cn
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 0aa85cc07ff1..c24c0e3440e3 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -3255,8 +3255,10 @@ static int __cdns3_gadget_init(struct cdns3 *cdns)
 	pm_runtime_get_sync(cdns->dev);
 
 	ret = cdns3_gadget_start(cdns);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync(cdns->dev);
 		return ret;
+	}
 
 	/*
 	 * Because interrupt line can be shared with other components in
-- 
2.30.2



