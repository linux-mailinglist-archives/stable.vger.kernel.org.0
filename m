Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC810137F65
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgAKKTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:19:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgAKKTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:19:31 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE2B520848;
        Sat, 11 Jan 2020 10:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737970;
        bh=RjKyGyHDjMtfKLgwT6hxJC6iWMeiB35CNzj+g9jOmzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hv+qoPhMTsY+2KyqFo/BeNBzlQ65GKzLSLkZUAplIrUJ+13ZpBYFPSC/6HpE3pxjf
         V6rVAfi1RXHpq5r5G3nMzGc1tYpuPQj1QLZCJwCMpGFABnw+T/qHatUU6o2MDRWhkE
         AGFCycip40ySkmy/EXoaqwBAzVLPJogrHd/eFTZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>
Subject: [PATCH 4.19 81/84] usb: dwc3: gadget: Fix request complete check
Date:   Sat, 11 Jan 2020 10:50:58 +0100
Message-Id: <20200111094912.700962986@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit ea0d762775e20aaff7909a3f0866ff1688b1c618 upstream.

We can only check for IN direction if the request had completed. For OUT
direction, it's perfectly fine that the host can send less than the
setup length. Let's return true fall all cases of OUT direction.

Fixes: e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Link: https://lore.kernel.org/r/ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2271,6 +2271,13 @@ static int dwc3_gadget_ep_reclaim_trb_li
 
 static bool dwc3_gadget_ep_request_completed(struct dwc3_request *req)
 {
+	/*
+	 * For OUT direction, host may send less than the setup
+	 * length. Return true for all OUT requests.
+	 */
+	if (!req->direction)
+		return true;
+
 	return req->request.actual == req->request.length;
 }
 


