Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E41549181
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350065AbiFMLBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350090AbiFMK7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:59:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53CC3120C;
        Mon, 13 Jun 2022 03:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F4ABCE0EEB;
        Mon, 13 Jun 2022 10:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12697C34114;
        Mon, 13 Jun 2022 10:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116370;
        bh=uue5EE1JeN8GGNUFiqBSIhubZNl+E5Jqm/EiHbqvVJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xmq/nhtTY9lenDyasPA5E8awsNHBrFk/ft8nAUPnxDuQnUm0v1oC+TncmRI1WLmfa
         2Ur+o4hPlWbBqNvhDzT0pqObiDNYi2HVUZeFhrM2rvoozip0SZaw8UXxOB3rMpnjBc
         o+gIROQATmPaSBWWdXVeCQK4GQFlTOQbPlyUtcvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/411] ARM: versatile: Add missing of_node_put in dcscb_init
Date:   Mon, 13 Jun 2022 12:05:43 +0200
Message-Id: <20220613094930.776135315@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 23b44f9c649bbef10b45fa33080cd8b4166800ae ]

The device_node pointer is returned by of_find_compatible_node
with refcount incremented. We should use of_node_put() to avoid
the refcount leak.

Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220428230356.69418-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-vexpress/dcscb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-vexpress/dcscb.c b/arch/arm/mach-vexpress/dcscb.c
index 46a903c88c6a..f553cde614f9 100644
--- a/arch/arm/mach-vexpress/dcscb.c
+++ b/arch/arm/mach-vexpress/dcscb.c
@@ -143,6 +143,7 @@ static int __init dcscb_init(void)
 	if (!node)
 		return -ENODEV;
 	dcscb_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!dcscb_base)
 		return -EADDRNOTAVAIL;
 	cfg = readl_relaxed(dcscb_base + DCS_CFG_R);
-- 
2.35.1



