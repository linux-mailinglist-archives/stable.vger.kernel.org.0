Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30A43D280B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhGVPy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhGVPyZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CD160FDA;
        Thu, 22 Jul 2021 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971700;
        bh=lm8q3fg6NoGfH1ve1OPJKIMh70Y8WFbsO6u/SdbsQu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0Z39mtFKr9781uAweMpW7rBgFLBRO0dnLyEUL8D21bkIKbJrHIoy6HMKHVml7q4K
         54g68UqrQsHRG7CDm7UXOdkNzAdwd+34wb5xBinLgEMR3zIVroFbEHTLScUUvov7WP
         HwTjRJ2ZBrYuD39unLyTyqJhwDhbAhsuqsBEuguM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 65/71] net: fddi: fix UAF in fza_probe
Date:   Thu, 22 Jul 2021 18:31:40 +0200
Message-Id: <20210722155620.071211318@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit deb7178eb940e2c5caca1b1db084a69b2e59b4c9 upstream.

fp is netdev private data and it cannot be
used after free_netdev() call. Using fp after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() after error message.

Fixes: 61414f5ec983 ("FDDI: defza: Add support for DEC FDDIcontroller 700
TURBOchannel adapter")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/fddi/defza.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/fddi/defza.c
+++ b/drivers/net/fddi/defza.c
@@ -1504,9 +1504,8 @@ err_out_resource:
 	release_mem_region(start, len);
 
 err_out_kfree:
-	free_netdev(dev);
-
 	pr_err("%s: initialization failure, aborting!\n", fp->name);
+	free_netdev(dev);
 	return ret;
 }
 


