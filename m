Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90666C0CE3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCTJOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjCTJNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B522386E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF957B80DB3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BF9C4339C;
        Mon, 20 Mar 2023 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679303608;
        bh=hqs03IDLKEgmndsWY5S/ABXuEzvs28bIFLC75nXZJVw=;
        h=Subject:To:Cc:From:Date:From;
        b=KQVJ6myCGfLOU3CI7hUIQi0fczxQW6GzlzEEK0H3fUV81y0+b1htiE5RbOnWKZlYh
         RC9V3IOnLONfqaynXpoXvioQLCJsl/Vg7mtSOqd8e5AhRg4q6/sM87263ziZcdJkn9
         sPFLeUAw0SvXFmvwsVG/zpknA6BX475FjIWBRSh8=
Subject: FAILED: patch "[PATCH] serial: 8250: ASPEED_VUART: select REGMAP instead of" failed to apply to 5.10-stable tree
To:     rdunlap@infradead.org, gregkh@linuxfoundation.org, osk@google.com,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 10:13:13 +0100
Message-ID: <167930359324157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x f8086d1a65ac693e3fd863128352b4b11ee7324d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930359324157@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

f8086d1a65ac ("serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it")
806a449725cb ("serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f8086d1a65ac693e3fd863128352b4b11ee7324d Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 25 Feb 2023 21:39:53 -0800
Subject: [PATCH] serial: 8250: ASPEED_VUART: select REGMAP instead of
 depending on it

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: 8d310c9107a2 ("drivers/tty/serial/8250: Make Aspeed VUART SIRQ polarity configurable")
Cc: stable <stable@kernel.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oskar Senft <osk@google.com>
Cc: linux-serial@vger.kernel.org
Link: https://lore.kernel.org/r/20230226053953.4681-9-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 978dc196c29b..caeff76e58f2 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -257,8 +257,9 @@ config SERIAL_8250_ASPEED_VUART
 	tristate "Aspeed Virtual UART"
 	depends on SERIAL_8250
 	depends on OF
-	depends on REGMAP && MFD_SYSCON
+	depends on MFD_SYSCON
 	depends on ARCH_ASPEED || COMPILE_TEST
+	select REGMAP
 	help
 	  If you want to use the virtual UART (VUART) device on Aspeed
 	  BMC platforms, enable this option. This enables the 16550A-

