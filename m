Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27443C4B6A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhGLG5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240609AbhGLG4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3956613C2;
        Mon, 12 Jul 2021 06:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072797;
        bh=itL04AeBuX2WMgoLulren7NArIq6YwfQrErwwYFUIpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9S4RplvNcYS692ssNK2gjch4v55HrYhlvW7ehCrZ6fdPHpC/3ogqBwnzjbHXcQAn
         5FhhdpsAFjiZApLazPngxYEK1SpMVbJ70wGHS+Shc41D9x0ZraKFMZBQq932DDP83y
         /4D1xDZl2SANO1D/xWfu5XW3QoeCvZo3oiu4si2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.12 024/700] usb: dwc3: Fix debugfs creation flow
Date:   Mon, 12 Jul 2021 08:01:47 +0200
Message-Id: <20210712060928.106582998@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 84524d1232ecca7cf8678e851b254f05cff4040a upstream.

Creation EP's debugfs called earlier than debugfs folder for dwc3
device created. As result EP's debugfs are created in '/sys/kernel/debug'
instead of '/sys/kernel/debug/usb/dwc3.1.auto'.

Moved dwc3_debugfs_init() function call before calling
dwc3_core_init_mode() to allow create dwc3 debugfs parent before
creating EP's debugfs's.

Fixes: 8d396bb0a5b6 ("usb: dwc3: debugfs: Add and remove endpoint dirs dynamically")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/01fafb5b2d8335e98e6eadbac61fc796bdf3ec1a.1623948457.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1605,17 +1605,18 @@ static int dwc3_probe(struct platform_de
 	}
 
 	dwc3_check_params(dwc);
+	dwc3_debugfs_init(dwc);
 
 	ret = dwc3_core_init_mode(dwc);
 	if (ret)
 		goto err5;
 
-	dwc3_debugfs_init(dwc);
 	pm_runtime_put(dev);
 
 	return 0;
 
 err5:
+	dwc3_debugfs_exit(dwc);
 	dwc3_event_buffers_cleanup(dwc);
 
 	usb_phy_shutdown(dwc->usb2_phy);


