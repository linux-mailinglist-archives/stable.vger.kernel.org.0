Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEB064327C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiLET0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiLET0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A4721BF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:22:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5954CB81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A3DC433C1;
        Mon,  5 Dec 2022 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268159;
        bh=zcbLxW8A+/qX2TinoCzZONiC97abHuXt0MaaBHh+8Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9hZj/YaF+dPPdD18pZAjHWi7TmQgyPMQIbkEu4WuDGSCerxOsodJwLDkuWbgI/l0
         a4SbsiMLUMjOnTyRzsNrccQlgomMBwYlHhu6jozj+3+M1Ac0I5OQsriAIiZFSC8Qom
         xmtRWpCr/JEnn2Me12krOBVxdlRylOJt3FQJlbQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/105] parisc: Increase size of gcc stack frame check
Date:   Mon,  5 Dec 2022 20:10:06 +0100
Message-Id: <20221205190806.296201818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 55b70eed81cba1331773d4aaf5cba2bb07475cd8 ]

parisc uses much bigger frames than other architectures, so increase the
stack frame check value to avoid compiler warnings.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9ded3c1f68eb..556aae95d69b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -224,7 +224,7 @@ config FRAME_WARN
 	range 0 8192
 	default 3072 if KASAN_EXTRA
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1280 if (!64BIT && PARISC)
+	default 1536 if (!64BIT && PARISC)
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
-- 
2.35.1



