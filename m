Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1D101553
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfKSFnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfKSFnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6960A208C3;
        Tue, 19 Nov 2019 05:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142179;
        bh=/B7P6C3sz8EfB+5MD85ITDTh140ifvbSFLrb8hBNBMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKSfcevbPxjHTuxegGvw9K2aDV+JAEo4D4mJPheW7DlK50RkNiDjdeTcHQh99Z7Mq
         yncYUemf0EySSaiFbrTvt+QAJ+JAivH6VRAvxEiyJpAWBvAb9wH0MlyN8EJEOvgWEF
         tvvkbv2w4D0sD5/BDXtP2LrVtZ6O5SFbBCHyS6iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 416/422] usb: usbtmc: uninitialized symbol actual in usbtmc_ioctl_clear
Date:   Tue, 19 Nov 2019 06:20:13 +0100
Message-Id: <20191119051426.152614625@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1016,6 +1016,7 @@ usbtmc_clear_check_status:
 		do {
 			dev_dbg(dev, "Reading from bulk in EP\n");
 
+			actual = 0;
 			rv = usb_bulk_msg(data->usb_dev,
 					  usb_rcvbulkpipe(data->usb_dev,
 							  data->bulk_in),
-- 
2.20.1



