Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F6E1CABF2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgEHMsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729672AbgEHMs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CD0024958;
        Fri,  8 May 2020 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942108;
        bh=HG1/7NbqLg821Uffw2Nc5LYBgGCvCn1rd0f7CbQ4axk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHSDmMA3ki318XiHpmUXe1j6IP53sJ4g8JIGvPq2j9X19LfZXWC/00OISM0KTV37t
         paZDmB9rwaxGUR0KM7Xg5FHFkzyXnpiBjZUSSYIA488SovXadznzNSBMAmsXw2Dg1+
         JrN+HgfoiEnuWRi3CKhH3t/Z4pz0KuY/HFGooMEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Hutchinson <b.hutchman@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 300/312] net: ethernet: davinci_emac: Fix platform_data overwrite
Date:   Fri,  8 May 2020 14:34:51 +0200
Message-Id: <20200508123145.516910614@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 210990b05a1247886539078e857cd038881bb2d6 upstream.

When the DaVinci emac driver is removed and re-probed, the actual
pdev->dev.platform_data is populated with an unwanted valid pointer saved by
the previous davinci_emac_of_get_pdata() call, causing a kernel crash when
calling priv->int_disable() in emac_int_disable().

Unable to handle kernel paging request at virtual address c8622a80
...
[<c0426fb4>] (emac_int_disable) from [<c0427700>] (emac_dev_open+0x290/0x5f8)
[<c0427700>] (emac_dev_open) from [<c04c00ec>] (__dev_open+0xb8/0x120)
[<c04c00ec>] (__dev_open) from [<c04c0370>] (__dev_change_flags+0x88/0x14c)
[<c04c0370>] (__dev_change_flags) from [<c04c044c>] (dev_change_flags+0x18/0x48)
[<c04c044c>] (dev_change_flags) from [<c052bafc>] (devinet_ioctl+0x6b4/0x7ac)
[<c052bafc>] (devinet_ioctl) from [<c04a1428>] (sock_ioctl+0x1d8/0x2c0)
[<c04a1428>] (sock_ioctl) from [<c014f054>] (do_vfs_ioctl+0x41c/0x600)
[<c014f054>] (do_vfs_ioctl) from [<c014f2a4>] (SyS_ioctl+0x6c/0x7c)
[<c014f2a4>] (SyS_ioctl) from [<c000ff60>] (ret_fast_syscall+0x0/0x1c)

Fixes: 42f59967a091 ("net: ethernet: davinci_emac: add OF support")
Cc: Brian Hutchinson <b.hutchman@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/davinci_emac.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1888,8 +1888,6 @@ davinci_emac_of_get_pdata(struct platfor
 		pdata->hw_ram_addr = auxdata->hw_ram_addr;
 	}
 
-	pdev->dev.platform_data = pdata;
-
 	return  pdata;
 }
 


