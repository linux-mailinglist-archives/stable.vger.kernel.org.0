Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24733C5061
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbhGLHcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346321AbhGLHap (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E156052B;
        Mon, 12 Jul 2021 07:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074876;
        bh=z78u4FnCESawygp0a3/7TFThvCKUdzycDjAGxi9Th/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeernMk3dYP3LmBQD3Os41iMywK1P5VF6dn4vgLQEb8vos7nQoBegiF0sSehAL/al
         BoroZC45b1EBgQ3/VhmQBN4ZI70Mm/FfaA9B1WOYxzvPKZX9KMNtXtx4us9NjURA53
         DldZ2U+v7bhG1mIPTIVPcQBQQjIVKTGMKtEngJAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.13 026/800] usb: dwc3: Fix debugfs creation flow
Date:   Mon, 12 Jul 2021 08:00:49 +0200
Message-Id: <20210712060916.810924519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -1616,17 +1616,18 @@ static int dwc3_probe(struct platform_de
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


