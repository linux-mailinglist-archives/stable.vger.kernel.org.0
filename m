Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C535EECED
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389060AbfKDWBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389055AbfKDWB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:29 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 904ED20650;
        Mon,  4 Nov 2019 22:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904889;
        bh=5VyfATjDRZ/d61SscXopb+AgGGmd7/YaQZLg5GFAo3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuzNLaIhYVIrJLhKPXgySqpeDiMHWuDvgZJp+t6iXh/4JQfO4MGs1Mz2u3AJ3Mwbs
         li+53gkCJ6wzhktLpUpQegUVEvtSP12OsJiwA3/fbdzK4jIZLo8O6uU7CffjV3Acfi
         qNPws35eDLDTp52r9yRiRA0FVceTqIp3NPiPu0e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/149] USB: legousbtower: fix a signedness bug in tower_probe()
Date:   Mon,  4 Nov 2019 22:44:59 +0100
Message-Id: <20191104212143.879043482@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



