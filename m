Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AB74CF59A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiCGJaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiCGJ23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914856B090;
        Mon,  7 Mar 2022 01:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14F846112D;
        Mon,  7 Mar 2022 09:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BC9C340E9;
        Mon,  7 Mar 2022 09:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645157;
        bh=7EQTP3caDLbMgaMUocONn2EQa/r2KSuWMN6iEvn5pkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5H6AIgf+dUlfMhzLNS1T8V2vQJRO6tNXnlnBfwdyNwf6NxIWo1ya9pqd9RaKOGMV
         XY+NuGyzOsVMnt33ahzqc+7f+iNp86XsSFKX1ifxlt2Pb5l1qDxnQ6gU+FL9crREdX
         Ieb7/ZhCucc18+tHKp4G2m4t96Fg0yL9AQERhy8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 33/51] net: stmmac: fix return value of __setup handler
Date:   Mon,  7 Mar 2022 10:19:08 +0100
Message-Id: <20220307091637.934519371@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit e01b042e580f1fbf4fd8da467442451da00c7a90 upstream.

__setup() handlers should return 1 on success, i.e., the parameter
has been handled. A return of 0 causes the "option=value" string to be
added to init's environment strings, polluting it.

Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Fixes: f3240e2811f0 ("stmmac: remove warning when compile as built-in (V2)")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Link: https://lore.kernel.org/r/20220224033536.25056-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4628,7 +4628,7 @@ static int __init stmmac_cmdline_opt(cha
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "debug:", 6)) {
 			if (kstrtoint(opt + 6, 0, &debug))
@@ -4659,11 +4659,11 @@ static int __init stmmac_cmdline_opt(cha
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("stmmaceth=", stmmac_cmdline_opt);


