Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3433B5493C2
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377942AbiFMNhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377950AbiFMNgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:36:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E721737A3;
        Mon, 13 Jun 2022 04:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B76A8CE1184;
        Mon, 13 Jun 2022 11:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF301C34114;
        Mon, 13 Jun 2022 11:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119634;
        bh=abkGmMOdu/QCux4ybU0A5MWLV/3jWK/Fgc2EYNAW6vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZ4VPANz/0EjdEVp+qbkj1xV47vKyyiYwOVUD8iDjUTQ5TSvbIXp83+sF3EIXQGRw
         y5okx/kC1AGbd8ZAhbAythvdxdskUAuWD+SbE+08eaLt5w1BEVLEiMMt0qKzEOrVr6
         szd3GG8v1dml6clR0hG2KTrz4M/Q+91m39l253Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 066/339] serial: cpm_uart: Fix build error without CONFIG_SERIAL_CPM_CONSOLE
Date:   Mon, 13 Jun 2022 12:08:11 +0200
Message-Id: <20220613094928.524276034@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 0258502f11a4f6036b5f8b34b09027c8a92def3a ]

drivers/tty/serial/cpm_uart/cpm_uart_core.c: In function ‘cpm_uart_init_port’:
drivers/tty/serial/cpm_uart/cpm_uart_core.c:1251:7: error: ‘udbg_port’ undeclared (first use in this function); did you mean ‘uart_port’?
  if (!udbg_port)
       ^~~~~~~~~
       uart_port

commit d142585bceb3 leave this corner, wrap it with #ifdef block

Fixes: d142585bceb3 ("serial: cpm_uart: Protect udbg definitions by CONFIG_SERIAL_CPM_CONSOLE")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20220518135452.39480-1-yuehaibing@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index d6d3db9c3b1f..db07d6a5d764 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1247,7 +1247,7 @@ static int cpm_uart_init_port(struct device_node *np,
 	}
 
 #ifdef CONFIG_PPC_EARLY_DEBUG_CPM
-#ifdef CONFIG_CONSOLE_POLL
+#if defined(CONFIG_CONSOLE_POLL) && defined(CONFIG_SERIAL_CPM_CONSOLE)
 	if (!udbg_port)
 #endif
 		udbg_putc = NULL;
-- 
2.35.1



