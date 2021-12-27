Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9247FFD3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238747AbhL0PlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbhL0Pjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEC3C061A72;
        Mon, 27 Dec 2021 07:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1C9ECE10CC;
        Mon, 27 Dec 2021 15:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5124EC36AEB;
        Mon, 27 Dec 2021 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619506;
        bh=Fi1tPZjmSqyKCi20s7OAZp6DL2Tu4++18xr7rSFuPA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuYqO4k8gxlcnEIkSYammImYaixSTmZ9x4HCzz6U1Wh3uuJJukHMPAlQzu0M3Xy1u
         8DYACdLY3NcY05pWR9RPLrdeVBy86gDzv0IKufKICCPALA5/go53AkdDVlucDYAzE4
         QLem/PF58dd2fNgkom75yOdLfF07mLWy0Cbc68jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 48/76] platform/x86: intel_pmc_core: fix memleak on registration failure
Date:   Mon, 27 Dec 2021 16:31:03 +0100
Message-Id: <20211227151326.366957180@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 26a8b09437804fabfb1db080d676b96c0de68e7c upstream.

In case device registration fails during module initialisation, the
platform device structure needs to be freed using platform_device_put()
to properly free all resources (e.g. the device name).

Fixes: 938835aa903a ("platform/x86: intel_pmc_core: do not create a static struct device")
Cc: stable@vger.kernel.org      # 5.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20211222105023.6205-1-johan@kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel_pmc_core_pltdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel_pmc_core_pltdrv.c
+++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
@@ -65,7 +65,7 @@ static int __init pmc_core_platform_init
 
 	retval = platform_device_register(pmc_core_device);
 	if (retval)
-		kfree(pmc_core_device);
+		platform_device_put(pmc_core_device);
 
 	return retval;
 }


