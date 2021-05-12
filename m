Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86D37C492
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhELPcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235451AbhELP2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D04136187E;
        Wed, 12 May 2021 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832376;
        bh=WNV2fhmnyMKswGOiuXFQtOcuDcETQzMMYAQu9w5egzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8KIyVdheO5I2B9W/Qm+5UQT78PAhmJ8MaTUmHOARK+fs3kZW02AStd/eqyG0hKOt
         0N+skHduvxXHXZdoKiZfNm95Ut50A86K8gFoQYX/p8VIPl4AiknBUQd4LXRVqp6eBr
         GO+lIfhE6IL5uORjYKKJoJzJ+e0otrRpn9Dai7Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ye Bin <yebin10@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/530] usbip: vudc: fix missing unlock on error in usbip_sockfd_store()
Date:   Wed, 12 May 2021 16:46:03 +0200
Message-Id: <20210512144828.153144771@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index f7633ee655a1..d1cf6b51bf85 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -156,12 +156,14 @@ static ssize_t usbip_sockfd_store(struct device *dev,
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



