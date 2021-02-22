Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBCF321714
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhBVMmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52847 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhBVMlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:41:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B1A464EEF;
        Mon, 22 Feb 2021 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997533;
        bh=RDAQ4yFCcAZJ92OXX7JBJgTLs9H9bazkxtbFRSElUn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzxwT3N265SUJ/8dMPswOTV0ueP54fbOOuTsVYxn0qyEv8qW7Ph8gMEdykYVtfEMz
         hip3NFmIQnSzLxRVqFLBdDKGIfgyHV/GpAMQRQGMN74dnE86RcrOzojxiPuaf82lkb
         ABlOwXUojl7Eqayv1Fp/1Sflk5F8xN97pKq8z4FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Greb <h3x4m3r0n@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 55/57] USB: Gadget Ethernet: Re-enable Jumbo frames.
Date:   Mon, 22 Feb 2021 13:36:21 +0100
Message-Id: <20210222121035.642232419@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Greb <h3x4m3r0n@gmail.com>

commit eea52743eb5654ec6f52b0e8b4aefec952543697 upstream

Fixes: <b3e3893e1253> ("net: use core MTU range checking")
which patched only one of two functions used to setup the
USB Gadget Ethernet driver, causing a serious performance
regression in the ability to increase mtu size above 1500.

Signed-off-by: John Greb <h3x4m3r0n@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -850,6 +850,10 @@ struct net_device *gether_setup_name_def
 	net->ethtool_ops = &ops;
 	SET_NETDEV_DEVTYPE(net, &gadget_type);
 
+	/* MTU range: 14 - 15412 */
+	net->min_mtu = ETH_HLEN;
+	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+
 	return net;
 }
 EXPORT_SYMBOL_GPL(gether_setup_name_default);


