Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75597F6573
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfKJCpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbfKJCpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C2EE21655;
        Sun, 10 Nov 2019 02:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353924;
        bh=Kp/Eu11Lwj/6ezzthePY2DchczQanvDiubDrKEivNAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vj4LKPpKsfmhgTNORmA8diwLqWEi3pg7hajGwKz/NPyAjDn9un10C8rWmaXKBhQ3q
         OfjCAqFwr60nn6DHAwazvaSgGGvGV1mFvFlKyUYmrmVfjGiFki3QxcNyqSiFvQYz6j
         ErdD9MkoGVqP/hLUJ1kGbw0qyDoZrYw/CPW5uNds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 185/191] usb: usbtmc: uninitialized symbol 'actual' in usbtmc_ioctl_clear
Date:   Sat,  9 Nov 2019 21:40:07 -0500
Message-Id: <20191110024013.29782-185-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Kiener <guido.kiener@rohde-schwarz.com>

[ Upstream commit 9a83190300867fb024d53f47c31088e34188efc1 ]

Fix uninitialized symbol 'actual' in function usbtmc_ioctl_clear.

When symbol 'actual' is not initialized and usb_bulk_msg() fails,
the subsequent kernel debug message shows a random value.

Signed-off-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Fixes: dfee02ac4bce ("usb: usbtmc: Fix ioctl USBTMC_IOCTL_CLEAR")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usbtmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 3ce45c9e9d20d..e6a7c86b70f25 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1016,6 +1016,7 @@ static int usbtmc_ioctl_clear(struct usbtmc_device_data *data)
 		do {
 			dev_dbg(dev, "Reading from bulk in EP\n");
 
+			actual = 0;
 			rv = usb_bulk_msg(data->usb_dev,
 					  usb_rcvbulkpipe(data->usb_dev,
 							  data->bulk_in),
-- 
2.20.1

