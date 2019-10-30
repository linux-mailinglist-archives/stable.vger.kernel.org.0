Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F55EA122
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfJ3P6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfJ3P6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:58:11 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A5521835;
        Wed, 30 Oct 2019 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451091;
        bh=iGHn6wtqcL1Csf3+sR5GQHWIShAWQe8Y3G598LkEWoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGMUAzD9iEnrz444cROMhrNwhFGpvBpZS/gkZuQNCDnFSiSOzfus1YqTct+RQK9Gx
         +D+0WjVl5/5qt4ePjXnN/fEb+lpljU2kK7KvQAa5HsNfKJxpAapmlwx6pY9wiWPiTR
         V1cYv/I/5CpYdO/LpJcV1XbGGLJSXPVNHwwqy1mE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        legousb-devel@lists.sourceforge.net, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/13] USB: legousbtower: fix a signedness bug in tower_probe()
Date:   Wed, 30 Oct 2019 11:57:46 -0400
Message-Id: <20191030155751.10960-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155751.10960-1-sashal@kernel.org>
References: <20191030155751.10960-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fd47a417e75e2506eb3672ae569b1c87e3774155 ]

The problem is that sizeof() is unsigned long so negative error codes
are type promoted to high positive values and the condition becomes
false.

Fixes: 1d427be4a39d ("USB: legousbtower: fix slab info leak at probe")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191011141115.GA4521@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/legousbtower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 32b41eb07f00e..8350ecfbcf21a 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -910,7 +910,7 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 				  get_version_reply,
 				  sizeof(*get_version_reply),
 				  1000);
-	if (result < sizeof(*get_version_reply)) {
+	if (result != sizeof(*get_version_reply)) {
 		if (result >= 0)
 			result = -EIO;
 		dev_err(idev, "get version request failed: %d\n", result);
-- 
2.20.1

