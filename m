Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FF59D8EC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348824AbiHWJWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349050AbiHWJUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8E448C8A;
        Tue, 23 Aug 2022 01:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCDB614E1;
        Tue, 23 Aug 2022 08:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873F8C433C1;
        Tue, 23 Aug 2022 08:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243575;
        bh=wL+I1X6OYqaa+s1yOlsuInujXPWsQqoekriR1F0yces=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asnP2eyaKWmf5kn84AMsHVpGTPMQKaZ6oxHiUBZ7rhUGdieNUsL6eF9dMwwBVbY/t
         rGBPWud6hY8DNxLS+YA4m0406m/fC7XlKOYbD7v+4a/NfwCtfQfI04O3y02UMu0u6Q
         QeVU7u2b+yLc5BdCgMarXvymISHGfH4SNS+HNjyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <timur@kernel.org>,
        Liang He <windhl@126.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 320/365] tty: serial: Fix refcount leak bug in ucc_uart.c
Date:   Tue, 23 Aug 2022 10:03:41 +0200
Message-Id: <20220823080131.574400568@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit d24d7bb2cd947676f9b71fb944d045e09b8b282f ]

In soc_info(), of_find_node_by_type() will return a node pointer
with refcount incremented. We should use of_node_put() when it is
not used anymore.

Acked-by: Timur Tabi <timur@kernel.org>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220618060850.4058525-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ucc_uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 6000853973c1..3cc9ef08455c 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1137,6 +1137,8 @@ static unsigned int soc_info(unsigned int *rev_h, unsigned int *rev_l)
 		/* No compatible property, so try the name. */
 		soc_string = np->name;
 
+	of_node_put(np);
+
 	/* Extract the SOC number from the "PowerPC," string */
 	if ((sscanf(soc_string, "PowerPC,%u", &soc) != 1) || !soc)
 		return 0;
-- 
2.35.1



