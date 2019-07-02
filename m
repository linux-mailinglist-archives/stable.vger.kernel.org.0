Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708555CB5F
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfGBIIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbfGBIIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C631821851;
        Tue,  2 Jul 2019 08:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054880;
        bh=31uGmOET+J+RLoI4uarHGQiKqoONVy4X9J/20Qq7JZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPfxFNqB7WL8I5TznqGxEWHU+AJFRisrlfo1+toeaPjZzz0ub2aSWqZDwPnZRIkpw
         hgRdy4mzGbri5R3bE4faBs/G50hfnTuelzhS6dpJ/IiYEgY+RpBYo+IAXSlU51hZsk
         RLq2NwhukpARyZDl9mTBZtflvHKbbOng18lBIjjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/72] Revert "usb: dwc3: gadget: Clear req->needs_extra_trb flag on cleanup"
Date:   Tue,  2 Jul 2019 10:01:24 +0200
Message-Id: <20190702080125.875012893@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 25ad17d692ad54c3c33b2a31e5ce2a82e38de14e,
as we will be cherry-picking a number of changes from upstream
that allows us to later cherry-pick the same fix from upstream
rather than using this modified backported version.

Cc: Fei Yang <fei.yang@intel.com>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19.y
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 65ba1038b111..eaa78e6c972c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -177,8 +177,6 @@ static void dwc3_gadget_del_and_unmap_request(struct dwc3_ep *dep,
 	req->started = false;
 	list_del(&req->list);
 	req->remaining = 0;
-	req->unaligned = false;
-	req->zero = false;
 
 	if (req->request.status == -EINPROGRESS)
 		req->request.status = status;
-- 
2.20.1



