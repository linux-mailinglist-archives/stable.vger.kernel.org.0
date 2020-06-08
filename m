Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088351F2E2B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgFIAjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbgFHXNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63053214D8;
        Mon,  8 Jun 2020 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657994;
        bh=MatvT71DNINJoflORw7IVwTHNc3bKAwQQ8ojtaV9jPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kehIeb7Eb9NNXbDlgt7BXXG6WEcsePeP0t0EXcHyBc/EwwxF8M9kRflGLF9jsgfMK
         HOvwmaPoZiDhNGQXdJg9QCrpTNa4HtvQDuapvJ+1JYzQ+htkeOGRjnD7G7AZDKtWyd
         pH/ozwCchPVMrXRPT8oAFvuMDhCIlSXq15sy4yGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 052/606] usb: gadget: legacy: fix error return code in gncm_bind()
Date:   Mon,  8 Jun 2020 19:02:57 -0400
Message-Id: <20200608231211.3363633-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit e27d4b30b71c66986196d8a1eb93cba9f602904a upstream.

If 'usb_otg_descriptor_alloc()' fails, we must return a
negative error code -ENOMEM, not 0.

Fixes: 1156e91dd7cc ("usb: gadget: ncm: allocate and init otg descriptor by otg capabilities")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/ncm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/ncm.c b/drivers/usb/gadget/legacy/ncm.c
index c61e71ba7045..0f1b45e3abd1 100644
--- a/drivers/usb/gadget/legacy/ncm.c
+++ b/drivers/usb/gadget/legacy/ncm.c
@@ -156,8 +156,10 @@ static int gncm_bind(struct usb_composite_dev *cdev)
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;
-- 
2.25.1

