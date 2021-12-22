Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583F247D050
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 11:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbhLVKvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 05:51:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47248 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbhLVKvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 05:51:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70FC9B81B9D;
        Wed, 22 Dec 2021 10:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7A3C36AE5;
        Wed, 22 Dec 2021 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640170268;
        bh=MUIobF7kB+qoPfsVPCz/wGBHLj3A4hegrXWkDmi1LyM=;
        h=From:To:Cc:Subject:Date:From;
        b=O1LV6JpQIRCWokfKZPuCMBXN1Wys6cIn7l2qgwdGKEDb67x8y3llTpVariRUGoPS+
         hslFSJ+Z5j4KVAJna9sU4uh3NAWa4LZ2+F1RC4jXvfddxsOwBgBgGzxkH0TPgwJ6uY
         l1/atFQzOyq6cgQm8krQn47TpPk5qNLvPnihWYJ3hQBp5nlgQFPEbJBPXta1VITJ0+
         kxsGylc1qdYHOE8sPBKDHmwq3MKXhNbGYN7vaxYJM0Pi4PgxGwqJIevp8d0d09s88h
         ESLNuxoqaNBr2exOza5hvohQ9VZCBnp1X5smPX4iiS82VIVL5gya7m3XPx2N4TdAxO
         x5lIcY4S2PKVw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mzzD2-0001dJ-Dy; Wed, 22 Dec 2021 11:51:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        David E Box <david.e.box@intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] platform/x86: intel_pmc_core: fix memleak on registration failure
Date:   Wed, 22 Dec 2021 11:50:23 +0100
Message-Id: <20211222105023.6205-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case device registration fails during module initialisation, the
platform device structure needs to be freed using platform_device_put()
to properly free all resources (e.g. the device name).

Fixes: 938835aa903a ("platform/x86: intel_pmc_core: do not create a static struct device")
Cc: stable@vger.kernel.org      # 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/platform/x86/intel/pmc/pltdrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/pltdrv.c b/drivers/platform/x86/intel/pmc/pltdrv.c
index 73797680b895..15ca8afdd973 100644
--- a/drivers/platform/x86/intel/pmc/pltdrv.c
+++ b/drivers/platform/x86/intel/pmc/pltdrv.c
@@ -65,7 +65,7 @@ static int __init pmc_core_platform_init(void)
 
 	retval = platform_device_register(pmc_core_device);
 	if (retval)
-		kfree(pmc_core_device);
+		platform_device_put(pmc_core_device);
 
 	return retval;
 }
-- 
2.32.0

