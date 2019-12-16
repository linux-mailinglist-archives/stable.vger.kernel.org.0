Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1B7121298
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfLPRyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfLPRyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7C8206D3;
        Mon, 16 Dec 2019 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518845;
        bh=URVkprWfAJWhyxcjKilsS7zegySLeavygfZpeHY4j3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJWtfuUuGJxZRBiaXlsL8elQkEBxJYg0hceXrDARLSb0EUYjoSs4//vZQa4anmRH0
         zs85zgdNiPsjRN8kPWdYhOOLaq/6XWk227Zw6Eh0hRfqEGKU7Y1d2UdEhAwy5bJ6l9
         ZbCpywNUw+bMQFTAOX3FrPtqXOu+fZxtzyLFmvwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 063/267] usb: dwc3: dont log probe deferrals; but do log other error codes
Date:   Mon, 16 Dec 2019 18:46:29 +0100
Message-Id: <20191216174855.820358372@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index 48755c501201d..a497b878c3e2b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1261,7 +1261,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	ret = dwc3_core_init(dwc);
 	if (ret) {
-		dev_err(dev, "failed to initialize core\n");
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "failed to initialize core: %d\n", ret);
 		goto err4;
 	}
 
-- 
2.20.1



