Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39734F3A61
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344030AbiDELo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354639AbiDEKO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC196A42D;
        Tue,  5 Apr 2022 03:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80295B818F6;
        Tue,  5 Apr 2022 10:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1EAC385A1;
        Tue,  5 Apr 2022 10:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152916;
        bh=GPaqH+1yLPZ4DKefbUNcGzaeDWSOf2VM3/SZ0PIjg+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0rjlYdR9iXt0zGFhuU9VCERsJmZP6Rjoat2inqOu3r9YjgfE5FNH16j0oaxRt4wM
         6D4YGZNOCaNOu65uP0eBPaYCa45aqvlR7LX7hAU2intBmfSQ69swypVlaNYHZfbyPn
         U0nJsvGicKSRJPhQSHHVA3zU5WieRdSAfCUZMEIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 5.10 004/599] hv: utils: add PTP_1588_CLOCK to Kconfig to fix build
Date:   Tue,  5 Apr 2022 09:24:58 +0200
Message-Id: <20220405070258.943153862@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 1dc2f2b81a6a9895da59f3915760f6c0c3074492 upstream.

The hyperv utilities use PTP clock interfaces and should depend a
a kconfig symbol such that they will be built as a loadable module or
builtin so that linker errors do not happen.

Prevents these build errors:

ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
hv_util.c:(.text+0x37d): undefined reference to `ptp_clock_unregister'
ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
hv_util.c:(.text+0x738): undefined reference to `ptp_clock_register'

Fixes: 3716a49a81ba ("hv_utils: implement Hyper-V PTP source")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: linux-hyperv@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20211126023316.25184-1-rdunlap@infradead.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Cc: Petr Štetiar <ynezz@true.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -17,6 +17,7 @@ config HYPERV_TIMER
 config HYPERV_UTILS
 	tristate "Microsoft Hyper-V Utilities driver"
 	depends on HYPERV && CONNECTOR && NLS
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Select this option to enable the Hyper-V Utilities.
 


