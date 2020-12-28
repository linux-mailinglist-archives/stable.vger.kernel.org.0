Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F472E40B6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501963AbgL1O4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441283AbgL1OQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA56E206D4;
        Mon, 28 Dec 2020 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165000;
        bh=jDSPTEhSlxTkOcOnMAMQu7TXmiAvvs+/mjmX0Io/OYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wq3E9ymFmI94s0H5zyPOZ2lXlEUXAXTqU7HInK+be9MfToL9urR/VaRWFA2Pw/yuJ
         o7/g2GSloqi2fkYI0uiqOTBWpKDa1HNQYLxraLqq/7VMKpKdGw6JOo+nBFKnyeE+dV
         W3FDWeklqrY+AU9IxNGgFm5O87R81M9ytVU3yfs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/717] usb: oxu210hp-hcd: Fix memory leak in oxu_create
Date:   Mon, 28 Dec 2020 13:46:11 +0100
Message-Id: <20201228125038.879134582@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit e5548b05631ec3e6bfdaef1cad28c799545b791b ]

usb_create_hcd will alloc memory for hcd, and we should
call usb_put_hcd to free it when adding fails to prevent
memory leak.

Fixes: b92a78e582b1a ("usb host: Oxford OXU210HP HCD driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201123145809.1456541-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/oxu210hp-hcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 27dbbe1b28b12..e832909a924fa 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -4151,8 +4151,10 @@ static struct usb_hcd *oxu_create(struct platform_device *pdev,
 	oxu->is_otg = otg;
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret < 0)
+	if (ret < 0) {
+		usb_put_hcd(hcd);
 		return ERR_PTR(ret);
+	}
 
 	device_wakeup_enable(hcd->self.controller);
 	return hcd;
-- 
2.27.0



