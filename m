Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA85E9F13
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiIZKTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiIZKRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:17:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40A8248F6;
        Mon, 26 Sep 2022 03:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C358CB80915;
        Mon, 26 Sep 2022 10:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBE6C433C1;
        Mon, 26 Sep 2022 10:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187293;
        bh=s9Ol33kpSrjmzFWdc4sW7eWoQqLfe0AJTiY9sp9s7jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfuqBeFVMZUATw87CLPFpdP8NWqYfmn68HD3OVurl4MIp24MQypeF+YDNmULEL3D7
         zmecIo5Z1wp0eT9Ygep9KTH1THkjOTbUJ2NHx+lQtCHO2i/rFmB8xUVRSEzd1JV5fL
         EkL095VdKZ7/7YeLFx05gVbQF8raptrfs0u8I9/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/30] mips: lantiq: falcon: Fix refcount leak bug in sysctrl
Date:   Mon, 26 Sep 2022 12:11:39 +0200
Message-Id: <20220926100736.453859021@linuxfoundation.org>
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



