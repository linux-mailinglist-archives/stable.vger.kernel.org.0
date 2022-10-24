Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE360A8A9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiJXNKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbiJXNI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:08:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78CD9F346;
        Mon, 24 Oct 2022 05:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C33361281;
        Mon, 24 Oct 2022 12:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35FBC433D6;
        Mon, 24 Oct 2022 12:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613998;
        bh=+uBp4s5k9w8OaQPz9fOORY0Wxie4lKxtfkqZIUFQYQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBdSz84r2PuOpPm5nrsWPAyWo7UJvpl1l1KHpRe5jbV3opKrv+5XoBbV9jLVll2ne
         UVixWpKrAA+f2/GlBWBBZbtF8vqqpzMt3ipJaMAdRLnk1NTUL+7amdm7WrHmd9kkf+
         1iOvIboklVsttToggmr943kYt2tsEYdex0JExQDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/390] MIPS: SGI-IP27: Free some unused memory
Date:   Mon, 24 Oct 2022 13:28:11 +0200
Message-Id: <20221024113026.645371712@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 33d7085682b4aa212ebfadbc21da81dfefaaac16 ]

platform_device_add_data() duplicates the memory it is passed. So we can
free some memory to save a few bytes that would remain unused otherwise.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 11bec9cba4de ("MIPS: SGI-IP27: Fix platform-device leak in bridge_platform_create()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip27/ip27-xtalk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index 000ede156bdc..e762886d1dda 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -53,6 +53,8 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	}
 	platform_device_add_resources(pdev, &w1_res, 1);
 	platform_device_add_data(pdev, wd, sizeof(*wd));
+	/* platform_device_add_data() duplicates the data */
+	kfree(wd);
 	platform_device_add(pdev);
 
 	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
@@ -83,6 +85,8 @@ static void bridge_platform_create(nasid_t nasid, int widget, int masterwid)
 	bd->io_offset	= offset;
 
 	platform_device_add_data(pdev, bd, sizeof(*bd));
+	/* platform_device_add_data() duplicates the data */
+	kfree(bd);
 	platform_device_add(pdev);
 	pr_info("xtalk:n%d/%x bridge widget\n", nasid, widget);
 	return;
-- 
2.35.1



