Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4855C57B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244720AbiF1C3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244596AbiF1C1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B093225C65;
        Mon, 27 Jun 2022 19:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E176172F;
        Tue, 28 Jun 2022 02:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB83C385A5;
        Tue, 28 Jun 2022 02:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383095;
        bh=anLhliyHGY0kXL0L8OJyHWPAZjs0KG+Pn8XaiHcCoq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZGUK2xLFoHic0/3wcr+WLBcDmvRjBCjdkWU1/HRmPI6wRGrQntM7qfpifr52/tB+
         oQuQw0+cRLrOQLiNkvflfZz+DclqSTOBYBiJ5g2kKQnvbDo8VF5tHY205+hIqLTx7Z
         qZgEEWKCh1w/Ui9n+1G41SeyqA8hi7Do18gUup8Il5iCzNkqRUsanh3/0DJh8EwA2m
         t9lD1cLViVUEt0pakT3sLAtX+TxYRslQEUkqOwJ+tCtcGZva7Udcozd/TQKsHDB2F/
         IJZil1Z/87GqrGiIe55YfyVMRGQ7a3smu2j0ytAkl+CJqB6gdZjtaPgq+bNR+1Szna
         7zQmBQNiPdvZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/27] mips: ralink: Fix refcount leak in of.c
Date:   Mon, 27 Jun 2022 22:24:04 -0400
Message-Id: <20220628022413.596341-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022413.596341-1-sashal@kernel.org>
References: <20220628022413.596341-1-sashal@kernel.org>
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

[ Upstream commit 48ca54e39173d1ed4c4dc8cf045484014bb26eaf ]

In plat_of_remap_node(), plat_of_remap_node() will return a node
pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/of.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index e2c71c6c667d..a5ebc376ff11 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -40,6 +40,8 @@ __iomem void *plat_of_remap_node(const char *node)
 	if (of_address_to_resource(np, 0, &res))
 		panic("Failed to get resource for %s", node);
 
+	of_node_put(np);
+
 	if (!request_mem_region(res.start,
 				resource_size(&res),
 				res.name))
-- 
2.35.1

