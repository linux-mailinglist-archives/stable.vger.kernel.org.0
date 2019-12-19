Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7C126A16
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfLSSoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbfLSSn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D7324680;
        Thu, 19 Dec 2019 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781038;
        bh=HlbDyFNZHpb3vx0ma2PmyfGDo+ZMxWe2ORxYgPZBxWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhpQCK1yfumoqa1TOks9rFyHCPULqEzeTSHenDi9TpbUA1blNBgBm/S8mMiCk8moR
         8YreRh/9jKnyhjEgpPhpD003qajG/i/HGAHtyD7nrIkZ9EPus2Ox0TkAZKTffhBvAl
         cPmMXWFfqmcdGdUNHz4Xjta9GVGUqK37WryY5jlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 040/199] usb: dwc3: dont log probe deferrals; but do log other error codes
Date:   Thu, 19 Dec 2019 19:32:02 +0100
Message-Id: <20191219183217.148335286@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 408d3ba006af57380fa48858b39f72fde6405031 ]

It's not very useful to repeat a bunch of probe deferral errors. And
it's also not very useful to log "failed" without telling the error
code.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 7154a93f01143..30bc5996a2f23 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1102,7 +1102,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	ret = dwc3_core_init(dwc);
 	if (ret) {
-		dev_err(dev, "failed to initialize core\n");
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "failed to initialize core: %d\n", ret);
 		goto err4;
 	}
 
-- 
2.20.1



