Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8385D38A405
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhETKAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235191AbhETJ5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DC961417;
        Thu, 20 May 2021 09:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503491;
        bh=T8g9gg3xXCtt6/4Yuk4vBuFDmMsNMgFryauksddq+rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HImKDZy83AGgwkrea1ye+zF6QMz76vrOUxRt91jTdfodbIFDHdeHRsZTlDOukjbbA
         KUCX/R/pJEe2INRLVGQjobV2IosK+4J5VO1HDa5eOKLz2beE505DYwY7xMH2Zw2Vmd
         cuii6D0bSkGmhWxjnv0p+Iw3QlBcH/Gl/AgjbInI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ye Bin <yebin10@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/425] usbip: vudc: fix missing unlock on error in usbip_sockfd_store()
Date:   Thu, 20 May 2021 11:19:47 +0200
Message-Id: <20210520092138.588628995@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 1d08ed588c6a85a35a24c82eb4cf0807ec2b366a ]

Add the missing unlock before return from function usbip_sockfd_store()
in the error handling case.

Fixes: bd8b82042269 ("usbip: vudc synchronize sysfs code paths")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20210408112305.1022247-1-yebin10@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vudc_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index de2babadd146..7b1437a51304 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -157,12 +157,14 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 		tcp_rx = kthread_create(&v_rx_loop, &udc->ud, "vudc_rx");
 		if (IS_ERR(tcp_rx)) {
 			sockfd_put(socket);
+			mutex_unlock(&udc->ud.sysfs_lock);
 			return -EINVAL;
 		}
 		tcp_tx = kthread_create(&v_tx_loop, &udc->ud, "vudc_tx");
 		if (IS_ERR(tcp_tx)) {
 			kthread_stop(tcp_rx);
 			sockfd_put(socket);
+			mutex_unlock(&udc->ud.sysfs_lock);
 			return -EINVAL;
 		}
 
-- 
2.30.2



