Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3154B1CAD7B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgEHMuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgEHMux (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52FB9218AC;
        Fri,  8 May 2020 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942252;
        bh=uYN8LZz1ibwe/IWmuFlzlOnteIFIM2ocNjVnNCs3UmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7Gs0mMGSglEZ62yoAUuFgAVkIl7RYNu42SlnwP0eovBLhe8TDolUZfIt10B4tvwt
         rDbWHvmXMJsCLIHCWSKs1R0mmtgkA3W2VJvy9TdYenD2tI4qaBkThxFciiWFF/8/vJ
         a88uOm/Sgm1VrKPP8o2OhkYiiVKjwJOMCw+42RE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/22] wimax/i2400m: Fix potential urb refcnt leak
Date:   Fri,  8 May 2020 14:35:20 +0200
Message-Id: <20200508123034.967844746@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123033.915895060@linuxfoundation.org>
References: <20200508123033.915895060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 7717cbec172c3554d470023b4020d5781961187e ]

i2400mu_bus_bm_wait_for_ack() invokes usb_get_urb(), which increases the
refcount of the "notif_urb".

When i2400mu_bus_bm_wait_for_ack() returns, local variable "notif_urb"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The issue happens in all paths of i2400mu_bus_bm_wait_for_ack(), which
forget to decrease the refcnt increased by usb_get_urb(), causing a
refcnt leak.

Fix this issue by calling usb_put_urb() before the
i2400mu_bus_bm_wait_for_ack() returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wimax/i2400m/usb-fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/usb-fw.c b/drivers/net/wimax/i2400m/usb-fw.c
index 502c346aa790b..7d396c81ec3eb 100644
--- a/drivers/net/wimax/i2400m/usb-fw.c
+++ b/drivers/net/wimax/i2400m/usb-fw.c
@@ -354,6 +354,7 @@ ssize_t i2400mu_bus_bm_wait_for_ack(struct i2400m *i2400m,
 		usb_autopm_put_interface(i2400mu->usb_iface);
 	d_fnend(8, dev, "(i2400m %p ack %p size %zu) = %ld\n",
 		i2400m, ack, ack_size, (long) result);
+	usb_put_urb(&notif_urb);
 	return result;
 
 error_exceeded:
-- 
2.20.1



