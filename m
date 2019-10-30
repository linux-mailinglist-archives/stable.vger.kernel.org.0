Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249DEEA0DD
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfJ3PzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727363AbfJ3PzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:55:05 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08DF020656;
        Wed, 30 Oct 2019 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450904;
        bh=5VyfATjDRZ/d61SscXopb+AgGGmd7/YaQZLg5GFAo3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcFH3O7vCQhGJkLrEJfzqMRUe/TI3ktFTDueQtmOvkDL9OaXp7Va1wHcxl1Dk3i0B
         WNckttiGoi6Cab5I1NdmrCvXGGDMV8ZN08DwMIE0vKCt1WHay6Z8VUtORoAANAjQhX
         XXRzdTAjWVpwETBY6lmSLLNNOfF3pexQaBbuY4ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        legousb-devel@lists.sourceforge.net, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/38] USB: legousbtower: fix a signedness bug in tower_probe()
Date:   Wed, 30 Oct 2019 11:53:49 -0400
Message-Id: <20191030155406.10109-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
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
index 62dab2441ec4f..23061f1526b4e 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -878,7 +878,7 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
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

