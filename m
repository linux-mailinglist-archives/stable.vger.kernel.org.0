Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACCB505817
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244634AbiDROA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244901AbiDRN6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:58:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8791A3B3;
        Mon, 18 Apr 2022 06:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F05A3B80D9C;
        Mon, 18 Apr 2022 13:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279FBC385A8;
        Mon, 18 Apr 2022 13:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287291;
        bh=J8tUB+BiV4zZV4I6SH2xKV9r1G8xQiet/Q5zMgRZqqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ji5wvozm+D2LwdEMQ/x1ULw6PK8kFZuKkfl6iJZ7zbueiJDCSOCLsktKJwEa05gwQ
         Xc7zgYqTwg4dR/+ga5V/UD/6UYj8fJiMASvJPtckhqJhrhq1T8gIE2DoOxTl7eBBsa
         4D/PCWhGKLCdCwUSsv6sODRK5b+kho5CKdwBoKj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 115/218] tty: hvc: fix return value of __setup handler
Date:   Mon, 18 Apr 2022 14:13:01 +0200
Message-Id: <20220418121202.885947895@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 53819a0d97aace1425bb042829e3446952a9e8a9 ]

__setup() handlers should return 1 to indicate that the boot option
has been handled or 0 to indicate that it was not handled.
Add a pr_warn() message if the option value is invalid and then
always return 1.

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: 86b40567b917 ("tty: replace strict_strtoul() with kstrtoul()")
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220308024228.20477-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_iucv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index 8b70a1627356..799bc191982c 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1469,7 +1469,9 @@ static int __init hvc_iucv_init(void)
  */
 static	int __init hvc_iucv_config(char *val)
 {
-	 return kstrtoul(val, 10, &hvc_iucv_devices);
+	if (kstrtoul(val, 10, &hvc_iucv_devices))
+		pr_warn("hvc_iucv= invalid parameter value '%s'\n", val);
+	return 1;
 }
 
 
-- 
2.34.1



