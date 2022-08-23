Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6DC59E3B6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbiHWM3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241570AbiHWM25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28426FEEA3;
        Tue, 23 Aug 2022 02:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3476A614F5;
        Tue, 23 Aug 2022 09:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040EEC433C1;
        Tue, 23 Aug 2022 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247805;
        bh=G31bJPoYMv94cqbiSEOGE7aQCgluitafdoR37mIssKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6H08plLZ4j3TZRZJsk1JpT7HCQYpafB32QipAeqXZNA0BBozxTgLa96sw/uhvd+l
         ZB65aywtuIaOMIPlXqqA8T6EEeokgajY+SvpDD52eq2G8SMKkXg836APvdsIQLXG4+
         QBewFYSiVWKm8QMNQJyMAd0WlBO0xwaGYbVSWkdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/158] mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start
Date:   Tue, 23 Aug 2022 10:27:47 +0200
Message-Id: <20220823080051.289584836@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

[ Upstream commit 7a9f743ceead60ed454c46fbc3085ee9a79cbebb ]

We should call of_node_put() for the reference 'uctl_node' returned by
of_get_parent() which will increase the refcount. Otherwise, there will
be a refcount leak bug.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index a994022e32c9..ce05c0dd3acd 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -86,11 +86,12 @@ static void octeon2_usb_clocks_start(struct device *dev)
 					 "refclk-frequency", &clock_rate);
 		if (i) {
 			dev_err(dev, "No UCTL \"refclk-frequency\"\n");
+			of_node_put(uctl_node);
 			goto exit;
 		}
 		i = of_property_read_string(uctl_node,
 					    "refclk-type", &clock_type);
-
+		of_node_put(uctl_node);
 		if (!i && strcmp("crystal", clock_type) == 0)
 			is_crystal_clock = true;
 	}
-- 
2.35.1



