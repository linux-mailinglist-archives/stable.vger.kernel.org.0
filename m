Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB7555CC7E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244999AbiF1CbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244894AbiF1C2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EEA26540;
        Mon, 27 Jun 2022 19:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C27FE6192A;
        Tue, 28 Jun 2022 02:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39712C341CB;
        Tue, 28 Jun 2022 02:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383240;
        bh=s9Ol33kpSrjmzFWdc4sW7eWoQqLfe0AJTiY9sp9s7jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dht7uEJOKMro1I7tuPargXAUrtcvWFlLCcd1LLQCWyfM1KUPrELrYKfVlyGZ5riHg
         j+fN/g+0MJnOKaNjsyb4sg8Ervrh++tKLNtOxdzu17We82cGlSnBqiUZ+rcK5ZC7lO
         1CU7eJ9LCF316FPknMfWiLpPuN/aj97Xyooj5+FIaBTR1wH8Tq7d8DbuIeNd049O5b
         CsceiQ5uU3CnavutkZj6Xe6JDUOkBfTS3wIA0zxglgAGrbijsO3iugv1hOWougzAfg
         7J4oV9JO32T0mnsNjRDrM5GKZveZgGNGEOvXsGaXsgFuRTF2dYo7zU3S+rdkO/Qgon
         YzW91RkuHcvDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        xkernel.wang@foxmail.com, wangborong@cdjrlc.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/13] mips: lantiq: falcon: Fix refcount leak bug in sysctrl
Date:   Mon, 27 Jun 2022 22:26:53 -0400
Message-Id: <20220628022657.597208-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022657.597208-1-sashal@kernel.org>
References: <20220628022657.597208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 72a2af539fff975caadd9a4db3f99963569bd9c9 ]

In ltq_soc_init(), of_find_compatible_node() will return a node pointer
with refcount incremented. We should use of_node_put() when it is not
used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/falcon/sysctrl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 714d92659489..665739bd4190 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -210,6 +210,12 @@ void __init ltq_soc_init(void)
 			of_address_to_resource(np_sysgpe, 0, &res_sys[2]))
 		panic("Failed to get core resources");
 
+	of_node_put(np_status);
+	of_node_put(np_ebu);
+	of_node_put(np_sys1);
+	of_node_put(np_syseth);
+	of_node_put(np_sysgpe);
+
 	if ((request_mem_region(res_status.start, resource_size(&res_status),
 				res_status.name) < 0) ||
 		(request_mem_region(res_ebu.start, resource_size(&res_ebu),
-- 
2.35.1

