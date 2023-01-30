Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387FC680F89
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbjA3Nyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbjA3Nyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A44FF30
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C41D6B8114D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01389C433EF;
        Mon, 30 Jan 2023 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086872;
        bh=5NJsybIQghShMJ80Aq4V6CkfKgvFew4w0zo6WL8aNZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxDbFH8ySW5Zx1/W2spDDa1hh3Fbo12MSBeb+Q+NzG5EMUM8x0mtowZPlQ2pIiUrL
         IulrpH5R15Y2w548PI8AC3FibldNDMlNzSLkLbwSWdjA9cG85IsVMItQmBlCd8DTGS
         xLAobGNHMpSNAVxPKHQxBtSwHqtV2nTTAQ/TDgbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <kristo@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/313] reset: ti-sci: honor TI_SCI_PROTOCOL setting when not COMPILE_TEST
Date:   Mon, 30 Jan 2023 14:47:39 +0100
Message-Id: <20230130134337.783252262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 13678f3feb3009b23aab424864fd0dac0765c83e ]

There is a build error when COMPILE_TEST=y, TI_SCI_PROTOCOL=m,
and RESET_TI_SCI=y:

drivers/reset/reset-ti-sci.o: in function `ti_sci_reset_probe':
reset-ti-sci.c:(.text+0x22c): undefined reference to `devm_ti_sci_get_handle'

Fix this by making RESET_TI_SCI honor the Kconfig setting of
TI_SCI_PROTOCOL when COMPILE_TEST is not set. When COMPILE_TEST is set,
TI_SCI_PROTOCOL must be disabled (=n).

Fixes: a6af504184c9 ("reset: ti-sci: Allow building under COMPILE_TEST")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Cc: Santosh Shilimkar <ssantosh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221030055636.3139-1-rdunlap@infradead.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index de176c2fbad9..2a52c990d4fe 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -257,7 +257,7 @@ config RESET_SUNXI
 
 config RESET_TI_SCI
 	tristate "TI System Control Interface (TI-SCI) reset driver"
-	depends on TI_SCI_PROTOCOL || COMPILE_TEST
+	depends on TI_SCI_PROTOCOL || (COMPILE_TEST && TI_SCI_PROTOCOL=n)
 	help
 	  This enables the reset driver support over TI System Control Interface
 	  available on some new TI's SoCs. If you wish to use reset resources
-- 
2.39.0



