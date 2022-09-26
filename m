Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639765E9F12
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiIZKTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiIZKRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:17:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCA53F31B;
        Mon, 26 Sep 2022 03:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 043A4B80918;
        Mon, 26 Sep 2022 10:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFB0C433D7;
        Mon, 26 Sep 2022 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187296;
        bh=lxvNlYhAytKwxZp4jMyRmt1FmbsAxMgDwEsNjVDEVwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gS5wrcZl/ITiqShZSMX0RdlS4mjelyqQPnuHmHTbQOGJOuH2B6k5XPrmjU4lqJb24
         pIB9mZSPEQIeByYwyybUwn6bBlSIzNICRj4kQaeKj8m8ObyKhrTz+24WQoJXeCtj2j
         4qyXmt7vZzKFONvkK7kcDNEvpviNkCNYxWM1SJ34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/30] mips: lantiq: xway: Fix refcount leak bug in sysctrl
Date:   Mon, 26 Sep 2022 12:11:40 +0200
Message-Id: <20220926100736.491653664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 76695592711ef1e215cc24ed3e1cd857d7fc3098 ]

In ltq_soc_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/sysctrl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index dd7c36a193e3..6891456a7603 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -457,6 +457,10 @@ void __init ltq_soc_init(void)
 			of_address_to_resource(np_ebu, 0, &res_ebu))
 		panic("Failed to get core resources");
 
+	of_node_put(np_pmu);
+	of_node_put(np_cgu);
+	of_node_put(np_ebu);
+
 	if (!request_mem_region(res_pmu.start, resource_size(&res_pmu),
 				res_pmu.name) ||
 		!request_mem_region(res_cgu.start, resource_size(&res_cgu),
-- 
2.35.1



