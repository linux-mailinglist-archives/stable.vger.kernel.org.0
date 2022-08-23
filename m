Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8910459DFB9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359299AbiHWMDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359154AbiHWL7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:59:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AD6D91CD;
        Tue, 23 Aug 2022 02:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AF5B60F50;
        Tue, 23 Aug 2022 09:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A435C433D6;
        Tue, 23 Aug 2022 09:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247262;
        bh=Wvy1Op3i9vLGrYZm4IwP35X3KGCfoZ+j8ssDJnCh2xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HU2Cv+N3Sd8qTtt7nr/EbcMLk1sk1Hl8ylyQ8u6O0Emf6G1JZyYdxTuSQg62foae+
         RPKu3MS/KgQ37FUZTygQI5rE0IQR2NN7gFEZxK2cml5lFzmMyRqwnMlbEh1mWKq68K
         jwP/fXETouRvNpwmyBylo2XBq1w5UlexGLv6R31s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <timur@kernel.org>,
        Liang He <windhl@126.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 370/389] tty: serial: Fix refcount leak bug in ucc_uart.c
Date:   Tue, 23 Aug 2022 10:27:28 +0200
Message-Id: <20220823080130.996168281@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index a0555ae2b1ef..181d55e0c60f 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1141,6 +1141,8 @@ static unsigned int soc_info(unsigned int *rev_h, unsigned int *rev_l)
 		/* No compatible property, so try the name. */
 		soc_string = np->name;
 
+	of_node_put(np);
+
 	/* Extract the SOC number from the "PowerPC," string */
 	if ((sscanf(soc_string, "PowerPC,%u", &soc) != 1) || !soc)
 		return 0;
-- 
2.35.1



