Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588E43DD7C8
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhHBNsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234375AbhHBNrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9EE061102;
        Mon,  2 Aug 2021 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912039;
        bh=3q494ZTRD0FYNLe8FGVRRXJETCXL4zPyz71GQjS4XJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slnjVH1AQ1dnnYfFb85Pw/qLORlV/3rIL0U3vahzdY3w2yb28vhCoxPXbt9e7qjk4
         +6ma7dnbJASO/wQY+iPxFwXlkSAsfEpgtLtYt/7dIdb0IG/Egw/Q5KsfSAzMm/P65W
         Y3b5eCG74zdWkYaHl25ojTpkvZYhWVN4vfYASru4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Shannon Nelson <shannon.lee.nelson@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Jakma <paul@jakma.org>
Subject: [PATCH 4.9 21/32] NIU: fix incorrect error return, missed in previous revert
Date:   Mon,  2 Aug 2021 15:44:41 +0200
Message-Id: <20210802134333.591427908@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Jakma <paul@jakma.org>

commit 15bbf8bb4d4ab87108ecf5f4155ec8ffa3c141d6 upstream.

Commit 7930742d6, reverting 26fd962, missed out on reverting an incorrect
change to a return value.  The niu_pci_vpd_scan_props(..) == 1 case appears
to be a normal path - treating it as an error and return -EINVAL was
breaking VPD_SCAN and causing the driver to fail to load.

Fix, so my Neptune card works again.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Fixes: 7930742d ('Revert "niu: fix missing checks of niu_pci_eeprom_read"')
Signed-off-by: Paul Jakma <paul@jakma.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/niu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -8213,8 +8213,9 @@ static int niu_pci_vpd_fetch(struct niu
 		err = niu_pci_vpd_scan_props(np, here, end);
 		if (err < 0)
 			return err;
+		/* ret == 1 is not an error */
 		if (err == 1)
-			return -EINVAL;
+			return 0;
 	}
 	return 0;
 }


