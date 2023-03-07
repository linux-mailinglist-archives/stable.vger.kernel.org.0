Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0A66AEEA5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjCGSNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjCGSNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967A17A937
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3BA8CE1C6A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA29BC433EF;
        Tue,  7 Mar 2023 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212562;
        bh=QWiufvSY18xyAYhN9U/7BhkGAcbUi0Aa4xBhKUhlFrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bxyc3k3LX5Uk0ivy/dwr0mytncgrbYfBjlOKpLSO3+Mex9jWnI/9gfHs76u1U04U7
         4Y90K6SpoAqKU39K0oK5tBFXPUm1cYLHfdoKkaNxwBdny4hmKdGPBIhqmeNGc8fuvB
         dHJFHgCzZFuEIpSQB4XGC+LKza5ghPbCpH1z2qf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/885] m68k: /proc/hardware should depend on PROC_FS
Date:   Tue,  7 Mar 2023 17:52:38 +0100
Message-Id: <20230307170011.785470958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1e5b5df65af99013b4d31607ddb3ca5731dbe44d ]

When CONFIG_PROC_FS is not set, there is a build error for an unused
function. Make PROC_HARDWARE depend on PROC_FS to prevent this error.

In file included from ../arch/m68k/kernel/setup.c:3:
../arch/m68k/kernel/setup_mm.c:477:12: error: 'hardware_proc_show' defined but not used [-Werror=unused-function]
  477 | static int hardware_proc_show(struct seq_file *m, void *v)
      |            ^~~~~~~~~~~~~~~~~~

Fixes: 66d857b08b8c ("m68k: merge m68k and m68knommu arch directories") # v3.0
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20230209010825.24136-1-rdunlap@infradead.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.devices | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 6a87b4a5fcac2..e6e3efac18407 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -19,6 +19,7 @@ config HEARTBEAT
 # We have a dedicated heartbeat LED. :-)
 config PROC_HARDWARE
 	bool "/proc/hardware support"
+	depends on PROC_FS
 	help
 	  Say Y here to support the /proc/hardware file, which gives you
 	  access to information about the machine you're running on,
-- 
2.39.2



