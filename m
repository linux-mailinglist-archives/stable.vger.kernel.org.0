Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426F72F5E6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfE3EvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbfE3DK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:59 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B60244E5;
        Thu, 30 May 2019 03:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185858;
        bh=6dIRTKo7ssCP3K7R1QhywNBy8AjmoCkBO+6/RAJolpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrl90rneYNy4ZDBmb/xcTRvRAn0r1MYeOwc2NdYCzMYKYqsvtXeIfKfRCgUhOLBnk
         t7ZDrzTQZXnnaOVGl3j17OTRTGWvOfrmQVnzZo/3fN5MUZ1bkNxOzw3OoAWMlN7sX6
         CPMyiH3JMxntGZsLbhyfMdIJ1xx2SKVowY3vrV9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 145/405] Bluetooth: mediatek: Fixed incorrect type in assignment
Date:   Wed, 29 May 2019 20:02:23 -0700
Message-Id: <20190530030548.463626535@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cac63f9b163700fb70a609ad220697c61b797d6b ]

Fixed warning: incorrect type in assignment reported by kbuild test robot.
The detailed warning is shown as below.

make ARCH=x86_64 allmodconfig
make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

All warnings (new ones prefixed by >>):

btmtkuart.c:671:18: sparse:    warning: incorrect type in assignment
			       (different base types)
btmtkuart.c:671:18: sparse:    expected unsigned int [usertype] baudrate
btmtkuart.c:671:18: sparse:    got restricted __le32 [usertype]

sparse warnings: (new ones prefixed by >>)
btmtkuart.c:671:18: sparse: warning: incorrect type in assignment
			       (different base types)
btmtkuart.c:671:18: sparse:    expected unsigned int [usertype] baudrate
btmtkuart.c:671:18: sparse:    got restricted __le32 [usertype]

vim +671 drivers/bluetooth/btmtkuart.c

   659
   660	static int btmtkuart_change_baudrate(struct hci_dev *hdev)
   661	{
   662		struct btmtkuart_dev *bdev = hci_get_drvdata(hdev);
   663		struct btmtk_hci_wmt_params wmt_params;
   664		u32 baudrate;
   665		u8 param;
   666		int err;
   667
   668		/* Indicate the device to enter the probe state the host is
   669		 * ready to change a new baudrate.
   670		 */
 > 671		baudrate = cpu_to_le32(bdev->desired_speed);
   672		wmt_params.op = MTK_WMT_HIF;

Fixes: 22eaf6c9946a ("Bluetooth: mediatek: add support for MediaTek MT7663U and MT7668U UART devices")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtkuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtkuart.c b/drivers/bluetooth/btmtkuart.c
index b0b680dd69f49..f5dbeec8e2748 100644
--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -661,7 +661,7 @@ static int btmtkuart_change_baudrate(struct hci_dev *hdev)
 {
 	struct btmtkuart_dev *bdev = hci_get_drvdata(hdev);
 	struct btmtk_hci_wmt_params wmt_params;
-	u32 baudrate;
+	__le32 baudrate;
 	u8 param;
 	int err;
 
-- 
2.20.1



