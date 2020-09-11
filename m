Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BF72666C7
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgIKRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgIKMzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1872223C;
        Fri, 11 Sep 2020 12:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828857;
        bh=QPYBtG8DEvhAdZkAPODVw70d/QOR5jMrzDGOOq4q1Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtUR3Kzu29+0Nlc7AI0tIhyDdRmkDNzuoL+NznLTPezCFuEhBxhnD+qBgxlbDKqX8
         j/VrKlWTUk732prE7rhzWSFVGZm2tywYobv78IagBD799Ll83RkWpik+y0l0ubCxig
         DX2r1W2LwEwyio4agIfW6/L6G6gWfw+LLz14pDS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 34/62] qmi_wwan: Added support for Gemaltos Cinterion PHxx WWAN interface
Date:   Fri, 11 Sep 2020 14:46:17 +0200
Message-Id: <20200911122504.092114873@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>

[ Upstream commit bd9e33508c5e1eb5d807d11d7bfc52125fcdb04e ]

Added support for Gemalto's Cinterion PHxx WWAN interfaces
by adding QMI_FIXED_INTF with Cinterion's VID and PID.

PHxx can have:
2 RmNet Interfaces (PID 0x0082) or
1 RmNet + 1 USB Audio interface (PID 0x0083).

Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 977df611164a6..ec03cf1f107bc 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -907,6 +907,9 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},	/* Olivetti Olicard 500 */
 	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 	{QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},	/* Cinterion PHxx,PXxx */
+	{QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},	/* Cinterion PHxx,PXxx (2 RmNet) */
+	{QMI_FIXED_INTF(0x1e2d, 0x0082, 5)},	/* Cinterion PHxx,PXxx (2 RmNet) */
+	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.25.1



