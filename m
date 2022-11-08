Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3773621413
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiKHN5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiKHN5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE45623A5
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 156CA6157B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A16AC433D6;
        Tue,  8 Nov 2022 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915823;
        bh=pCWBY7IotSTWVSzubmWeVF7vAVa+u9ogasTT4Ry/6T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXWEuxp9B51rYpvGpH/r1wwQRKLFgeO0fzgqZksnBDhhMopiwVto6pDMAL0JUEblM
         jbpIv+WCl23cqNaP9AjPz+yUMFbcAne5ksJC8zmO5EL7QoHZOwEmxhdealwwE/tg/F
         EQuLkRUc3QoAAzrqPZcK+LGJmjs9NlLvUNOYsLlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 101/118] parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
Date:   Tue,  8 Nov 2022 14:39:39 +0100
Message-Id: <20221108133345.111826917@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit e8a18e3f00f3ee8d07c17ab1ea3ad4df4a3b6fe0 upstream.

Although the name of the driver 8250_gsc.c suggests that it handles
only serial ports on the GSC bus, it does handle serial ports listed
in the parisc machine inventory as well, e.g. the serial ports in a
C8000 PCI-only workstation.

Change the dependency to CONFIG_PARISC, so that the driver gets included
in the kernel even if CONFIG_GSC isn't set.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -119,7 +119,7 @@ config SERIAL_8250_CONSOLE
 
 config SERIAL_8250_GSC
 	tristate
-	depends on SERIAL_8250 && GSC
+	depends on SERIAL_8250 && PARISC
 	default SERIAL_8250
 
 config SERIAL_8250_DMA


