Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA623D2A32
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhGVQKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234532AbhGVQHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3943761363;
        Thu, 22 Jul 2021 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972489;
        bh=lm8q3fg6NoGfH1ve1OPJKIMh70Y8WFbsO6u/SdbsQu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkYgPR1ZjmIJRme0IcfdIesFDpYYGPHlKoCcuvVkXUA2stfKDZjGeVulaBDRACZnH
         q7INQ6224AbgcIPNmGXJ5rczkHhwwDWBcJHvkqL9OrjVFD+RgpSfIbABDzVkSgySys
         5uok8OwbIxRjdpW4pjsGXrmjDsyIaAzRfvrZKyGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 133/156] net: fddi: fix UAF in fza_probe
Date:   Thu, 22 Jul 2021 18:31:48 +0200
Message-Id: <20210722155632.653985218@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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
 


