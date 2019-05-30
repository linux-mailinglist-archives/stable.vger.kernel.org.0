Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8642EFB0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbfE3D5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731724AbfE3DSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AFC62479B;
        Thu, 30 May 2019 03:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186328;
        bh=U6QRBARhgUq1qClnks2XAmFSTxuDMrCfnmBuBHfkHUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqNnwFGJIaOd4KfXGuyBjMwsvwmTuui1lbekDmilgWEip79KeSAQrfYMlpjg8zF4Z
         C+6zmpxShMHMn/sWeVHXhrr8RUIomO5ef9aCneVjNi3JOEesNsJIB6Z6/v3UPCOj3p
         GPLjysf+aC1Gi3aWVgAau/Uwr0gidZfi+0j2JBGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/193] net: ena: gcc 8: fix compilation warning
Date:   Wed, 29 May 2019 20:04:58 -0700
Message-Id: <20190530030455.777703122@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f913308879bc6ae437ce64d878c7b05643ddea44 ]

GCC 8 contains a number of new warnings as well as enhancements to existing
checkers. The warning - Wstringop-truncation - warns for calls to bounded
string manipulation functions such as strncat, strncpy, and stpncpy that
may either truncate the copied string or leave the destination unchanged.

In our case the destination string length (32 bytes) is much shorter than
the source string (64 bytes) which causes this warning to show up. In
general the destination has to be at least a byte larger than the length
of the source string with strncpy for this warning not to showup.

This can be easily fixed by using strlcpy instead which already does the
truncation to the string. Documentation for this function can be
found here:

https://elixir.bootlin.com/linux/latest/source/lib/string.c#L141

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3c7813f04962b..db6f6a877f630 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2229,7 +2229,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev)
 
 	host_info->os_type = ENA_ADMIN_OS_LINUX;
 	host_info->kernel_ver = LINUX_VERSION_CODE;
-	strncpy(host_info->kernel_ver_str, utsname()->version,
+	strlcpy(host_info->kernel_ver_str, utsname()->version,
 		sizeof(host_info->kernel_ver_str) - 1);
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
-- 
2.20.1



