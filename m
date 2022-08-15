Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BBD595088
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiHPEmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiHPElm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:41:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F681709DB;
        Mon, 15 Aug 2022 13:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E73611DB;
        Mon, 15 Aug 2022 20:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011A7C433D6;
        Mon, 15 Aug 2022 20:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595656;
        bh=Jrrwpx5iQuNpEFJqO6sMVwwy8PYagWRKnEgBRYZS9fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m13Xt/WWQ1QlRBcVIddBIbJbu+zAjxw+T1s8qCfzpu52MRoBFxVpGP1vvi4MnMK7K
         SCmIH+7f0fEFTPoo5rbPjoiZID8ZiB6cVPPnlJDhKcuaVNSKowsL2rpSThMsyOWneT
         YYdvTjKLxJus1npcna0ESwStfCQwf8lmfJq1+TVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0791/1157] rtla/utils: Use calloc and check the potential memory allocation failure
Date:   Mon, 15 Aug 2022 20:02:27 +0200
Message-Id: <20220815180511.112567675@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jianchunfu <jianchunfu@cmss.chinamobile.com>

[ Upstream commit b5f37a0b6f667f5c72340ca9dcd7703f261cb981 ]

Replace malloc with calloc and add memory allocating check
of mon_cpus before used.

Link: https://lkml.kernel.org/r/20220615073348.6891-1-jianchunfu@cmss.chinamobile.com

Fixes: 7d0dc9576dc3 ("rtla/timerlat: Add --dma-latency option")
Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 5352167a1e75..5ae2fa96fde1 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -106,8 +106,9 @@ int parse_cpu_list(char *cpu_list, char **monitored_cpus)
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
 
-	mon_cpus = malloc(nr_cpus * sizeof(char));
-	memset(mon_cpus, 0, (nr_cpus * sizeof(char)));
+	mon_cpus = calloc(nr_cpus, sizeof(char));
+	if (!mon_cpus)
+		goto err;
 
 	for (p = cpu_list; *p; ) {
 		cpu = atoi(p);
-- 
2.35.1



