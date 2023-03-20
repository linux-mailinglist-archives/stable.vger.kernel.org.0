Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C5C6C1942
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjCTPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbjCTPb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DA92A163
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BEDC614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3A7C433D2;
        Mon, 20 Mar 2023 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325871;
        bh=4dgyGaiHkVLcwecfj5mvgWM9vlM+Ly+omg4kwrWyhgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWxhsbH9NxPPkDB3Uq9/x+QBrVax4h+eNXQ73xGQx+bf3d6JwZXiIUWHRFn7VxoJ9
         p1LFDENB57TmIfq8PulmCR0e7SZDo7KtOhrAMOxquBdYj4TZdV95djZqA69QUHaSJr
         ufLO4231ICB/J2DzTMajOGkIGcZAHkZv9NFi+psQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.2 117/211] Revert "tty: serial: fsl_lpuart: adjust SERIAL_FSL_LPUART_CONSOLE config dependency"
Date:   Mon, 20 Mar 2023 15:54:12 +0100
Message-Id: <20230320145518.236894579@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 2d638be71155b2e036aca1966b6129e2d661e91f upstream.

This reverts commit 5779a072c248db7a40cfd0f5ea958097fd1d9a30.

This results in a link error of

ld: drivers/tty/serial/earlycon.o: in function `parse_options':
drivers/tty/serial/earlycon.c:99: undefined reference to `uart_parse_earlycon'

When the config is in this state

CONFIG_SERIAL_CORE=m
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y

Fixes: 5779a072c248 ("tty: serial: fsl_lpuart: adjust SERIAL_FSL_LPUART_CONSOLE config dependency")
Cc: stable <stable@kernel.org>
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230226173846.236691-1-trix@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1313,7 +1313,7 @@ config SERIAL_FSL_LPUART
 
 config SERIAL_FSL_LPUART_CONSOLE
 	bool "Console on Freescale lpuart serial port"
-	depends on SERIAL_FSL_LPUART
+	depends on SERIAL_FSL_LPUART=y
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 	help


