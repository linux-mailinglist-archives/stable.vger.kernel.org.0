Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181845E9F11
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiIZKTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbiIZKRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:17:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AFA3F32F;
        Mon, 26 Sep 2022 03:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB3060BBF;
        Mon, 26 Sep 2022 10:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DFEC433D6;
        Mon, 26 Sep 2022 10:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187303;
        bh=rrDhxUZ7JRFCLEk5L6AChGIzQ8M4z5nHZqc1JCT5t+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jY+Apsp7oerkpNar9f91JsugwzLwGz9u5c/tWZBWv3/OCCNg5snwsIHiHcJtwwKE0
         2CGCluPoXJSL6pqqoqEKMDpdGifj/LR2ubkNIqOr5vVpsg9dEraAA00eHzdWzMmjmE
         be1hkTTM4cbg+CrQ/QbXpqS0MpbPjKZhlDFBlRtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/30] mips: lantiq: Add missing of_node_put() in irq.c
Date:   Mon, 26 Sep 2022 12:11:42 +0200
Message-Id: <20220926100736.579467679@linuxfoundation.org>
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

[ Upstream commit 3748d2185ac4c2c6f80989672253aad909ecaf95 ]

In icu_of_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index e64f678ca12c..e29dc58271b2 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -460,6 +460,7 @@ int __init icu_of_init(struct device_node *node, struct device_node *parent)
 		if (!ltq_eiu_membase)
 			panic("Failed to remap eiu memory");
 	}
+	of_node_put(eiu_node);
 
 	return 0;
 }
-- 
2.35.1



