Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87B4CF947
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiCGKE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbiCGJ5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:57:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1577B575;
        Mon,  7 Mar 2022 01:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6E92613CA;
        Mon,  7 Mar 2022 09:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B39C340F3;
        Mon,  7 Mar 2022 09:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646357;
        bh=SaOWSdfpn9CGBVS1B4toCBOUU00mGD5nHWoK8cA+Qkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHYvmsD7NbHumFWhZoYYAKsLXcjU+zWBh7o2ZQ/PZ3qtj0zmZ3543+Alnj7psJwB7
         ItldZjsB52kp/xiqxMjpu9St8TdXrv6wIdTvHdcshO06/VPuxDK6+bgTp0ZN/OUSVq
         oo/fO8Ac/9RFyR4sZ8bjFMtPQIR4MfN6vzPrhCbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Siva Reddy <siva.kallam@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Byungho An <bh74.an@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 177/262] net: sxgbe: fix return value of __setup handler
Date:   Mon,  7 Mar 2022 10:18:41 +0100
Message-Id: <20220307091707.414229455@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

commit 50e06ddceeea263f57fe92baa677c638ecd65bb6 upstream.

__setup() handlers should return 1 on success, i.e., the parameter
has been handled. A return of 0 causes the "option=value" string to be
added to init's environment strings, polluting it.

Fixes: acc18c147b22 ("net: sxgbe: add EEE(Energy Efficient Ethernet) for Samsung sxgbe")
Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Siva Reddy <siva.kallam@samsung.com>
Cc: Girish K S <ks.giri@samsung.com>
Cc: Byungho An <bh74.an@samsung.com>
Link: https://lore.kernel.org/r/20220224033528.24640-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2282,18 +2282,18 @@ static int __init sxgbe_cmdline_opt(char
 	char *opt;
 
 	if (!str || !*str)
-		return -EINVAL;
+		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "eee_timer:", 10)) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
 		}
 	}
-	return 0;
+	return 1;
 
 err:
 	pr_err("%s: ERROR broken module parameter conversion\n", __func__);
-	return -EINVAL;
+	return 1;
 }
 
 __setup("sxgbeeth=", sxgbe_cmdline_opt);


