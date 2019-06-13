Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD35443F1B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbfFMPyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731569AbfFMIx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:53:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC5D215EA;
        Thu, 13 Jun 2019 08:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560416008;
        bh=id9fzv7nyH1zGmy4h3HEUh/wcEv+8VdU11in07z9XYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W605ZCzfzg5X2UVloHAskRMdeqLYvM86aLzb7QNZYXkePZuGqf2AkhGJugu2MNPJr
         jWUUnLvqm/qFA7JgfoSKDbTQQ6Gtb5BgYDDesZd6/lhZqSfa8AC3y9QjrDs6hP31cn
         IPbRKaoJPsqSOPESmvJlqDJuAGXHeFB1mW8yAMKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kuo, Hsuan-Chi" <hckuo2@illinois.edu>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 069/155] watchdog: fix compile time error of pretimeout governors
Date:   Thu, 13 Jun 2019 10:33:01 +0200
Message-Id: <20190613075656.842528232@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a223770bfa7b6647f3a70983257bd89f9cafce46 ]

CONFIG_WATCHDOG_PRETIMEOUT_GOV build symbol adds watchdog_pretimeout.o
object to watchdog.o, the latter is compiled only if CONFIG_WATCHDOG_CORE
is selected, so it rightfully makes sense to add it as a dependency.

The change fixes the next compilation errors, if CONFIG_WATCHDOG_CORE=n
and CONFIG_WATCHDOG_PRETIMEOUT_GOV=y are selected:

  drivers/watchdog/pretimeout_noop.o: In function `watchdog_gov_noop_register':
  drivers/watchdog/pretimeout_noop.c:35: undefined reference to `watchdog_register_governor'
  drivers/watchdog/pretimeout_noop.o: In function `watchdog_gov_noop_unregister':
  drivers/watchdog/pretimeout_noop.c:40: undefined reference to `watchdog_unregister_governor'

  drivers/watchdog/pretimeout_panic.o: In function `watchdog_gov_panic_register':
  drivers/watchdog/pretimeout_panic.c:35: undefined reference to `watchdog_register_governor'
  drivers/watchdog/pretimeout_panic.o: In function `watchdog_gov_panic_unregister':
  drivers/watchdog/pretimeout_panic.c:40: undefined reference to `watchdog_unregister_governor'

Reported-by: Kuo, Hsuan-Chi <hckuo2@illinois.edu>
Fixes: ff84136cb6a4 ("watchdog: add watchdog pretimeout governor framework")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 1d3b4bfbbc4d..d4d6c5b2bef3 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -2028,6 +2028,7 @@ comment "Watchdog Pretimeout Governors"
 
 config WATCHDOG_PRETIMEOUT_GOV
 	bool "Enable watchdog pretimeout governors"
+	depends on WATCHDOG_CORE
 	help
 	  The option allows to select watchdog pretimeout governors.
 
-- 
2.20.1



