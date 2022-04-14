Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3589D501412
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbiDNNn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbiDNNep (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:34:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E786B92D03;
        Thu, 14 Apr 2022 06:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E5FA61B51;
        Thu, 14 Apr 2022 13:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D45C385B9;
        Thu, 14 Apr 2022 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943062;
        bh=GPaqH+1yLPZ4DKefbUNcGzaeDWSOf2VM3/SZ0PIjg+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifSNwHVu5ARvKNSeV/Ur6yesCB5YtGkvj0vgqmdmrUQ6HtEH1dE8Ydh1xXVIuviul
         r8r6Mm1OScr4sOhm6gnvSY3XSVrxTf2hBhK2c+n1HcTUzKCNmEKtPCN6dmdAKbd3Td
         W2FeWY0U8Mh6b7AoF+ftO53qGjANpu9KCBfg4HFY=
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
Subject: [PATCH 5.4 004/475] hv: utils: add PTP_1588_CLOCK to Kconfig to fix build
Date:   Thu, 14 Apr 2022 15:06:29 +0200
Message-Id: <20220414110855.274446341@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
 


