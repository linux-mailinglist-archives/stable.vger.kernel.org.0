Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEEA6214C3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiKHOE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiKHOE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:04:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E4E686B8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:04:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11806B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6007DC4347C;
        Tue,  8 Nov 2022 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916292;
        bh=AWf0R6K18xkj7EV8Yp1PuXUx/YE162l+Ucex8+SyTnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgjtZOZEd65SQLyyDJ0hsyinz4qBKsXwDSc6AP/ooeU1gOtlKGTWMUgfI2Z2kIRad
         XrEAy2N7e+n+Ws8Ugq2PHXetuEmitrn6Pt15LNGJuTsO6PLKONfSLAdFQZRKVMQbx/
         ITbVJ6/Kb86pTGW2yDv4a+9U0l5iROsOhXFBZNZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 120/144] parisc: Make 8250_gsc driver dependend on CONFIG_PARISC
Date:   Tue,  8 Nov 2022 14:39:57 +0100
Message-Id: <20221108133350.365611519@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
@@ -118,7 +118,7 @@ config SERIAL_8250_CONSOLE
 
 config SERIAL_8250_GSC
 	tristate
-	depends on SERIAL_8250 && GSC
+	depends on SERIAL_8250 && PARISC
 	default SERIAL_8250
 
 config SERIAL_8250_DMA


