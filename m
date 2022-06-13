Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BA154903D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381030AbiFMOMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380985AbiFMOKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC4B99806;
        Mon, 13 Jun 2022 04:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891226124E;
        Mon, 13 Jun 2022 11:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9595CC34114;
        Mon, 13 Jun 2022 11:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120510;
        bh=abkGmMOdu/QCux4ybU0A5MWLV/3jWK/Fgc2EYNAW6vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HK2aIY3+TXzKle6nEjGSEcvHEfgN8FQBgCrDB7Xo4gc/VxMsHvwYMxCKTYTb3M+lm
         o/3erCZFSPebpSxnqtvM/Spxz8ao3YsaNQ6es/aOPVNmdtP/YJ7IuMhHWBIZ6K0C1h
         UDf6stGzBOEp8S+t9gYpnBb+ycSPMYoXpiOu/1AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 058/298] serial: cpm_uart: Fix build error without CONFIG_SERIAL_CPM_CONSOLE
Date:   Mon, 13 Jun 2022 12:09:12 +0200
Message-Id: <20220613094926.710114737@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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



