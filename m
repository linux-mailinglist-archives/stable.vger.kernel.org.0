Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188FBE6863
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfJ0VTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbfJ0VTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:18 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22449214E0;
        Sun, 27 Oct 2019 21:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211157;
        bh=HZt28qeJ9roEqr1pQ7f0oFDZLmYIjlhJZ2bgYQLGM9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hwAM38N9Pq/nbyaw0cu3kPTSkOHjVb1IGrdfcyfXeXnZlRqp8UDlgmQ96Vx3ID8Y
         UWt9/qq5fVSQalJyVz1AEXxYBhduclDXngv3IT6flvKdE8u6rAJELp0gpmsmbO/X2i
         2x4ps6HQhsCUTvqVW+kuB/dedYINoFUEuxGenCQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 053/197] r8152: Set macpassthru in reset_resume callback
Date:   Sun, 27 Oct 2019 21:59:31 +0100
Message-Id: <20191027203354.543257012@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit a54cdeeb04fc719e4c7f19d6e28dba7ea86cee5b ]

r8152 may fail to establish network connection after resume from system
suspend.

If the USB port connects to r8152 lost its power during system suspend,
the MAC address was written before is lost. The reason is that The MAC
address doesn't get written again in its reset_resume callback.

So let's set MAC address again in reset_resume callback. Also remove
unnecessary lock as no other locking attempt will happen during
reset_resume.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 04137ac373b07..9eedc0714422c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4533,10 +4533,9 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	struct r8152 *tp = usb_get_intfdata(intf);
 
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
-	mutex_lock(&tp->control);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	mutex_unlock(&tp->control);
+	set_ethernet_addr(tp);
 	return rtl8152_resume(intf);
 }
 
-- 
2.20.1



