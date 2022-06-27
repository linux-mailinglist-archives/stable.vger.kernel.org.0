Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B769755DA0B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiF0Lyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiF0Lwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997C7DEE6;
        Mon, 27 Jun 2022 04:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3536061188;
        Mon, 27 Jun 2022 11:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46455C3411D;
        Mon, 27 Jun 2022 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330367;
        bh=XD01nU63sTO0XqJJuZPfLOromHDSrYBbyMEACs/xTzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sq9wefwreD5VhPE2KY0xzxIFCeDaQFqYDcHPdv8PHAM0cSFJGlA1kcj4yergMW63l
         +B32FCvfkIAKR6U8WZzkIRG2L1Y9dqHPuVWnpA1Wvg4iEYN6CzDkcY8qZYU9rym1pR
         gpxFnqnpf5vc6j8mSS6Li5BsSnb4T1abhDRI0Pg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.18 172/181] ARM: cns3xxx: Fix refcount leak in cns3xxx_init
Date:   Mon, 27 Jun 2022 13:22:25 +0200
Message-Id: <20220627111949.672778263@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 1ba904b6b16e08de5aed7c1349838d9cd0d178c5 upstream.

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 415f59142d9d ("ARM: cns3xxx: initial DT support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Krzysztof Halasa <khalasa@piap.pl>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-cns3xxx/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -372,6 +372,7 @@ static void __init cns3xxx_init(void)
 		/* De-Asscer SATA Reset */
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SATA));
 	}
+	of_node_put(dn);
 
 	dn = of_find_compatible_node(NULL, NULL, "cavium,cns3420-sdhci");
 	if (of_device_is_available(dn)) {
@@ -385,6 +386,7 @@ static void __init cns3xxx_init(void)
 		cns3xxx_pwr_clk_en(CNS3XXX_PWR_CLK_EN(SDIO));
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SDIO));
 	}
+	of_node_put(dn);
 
 	pm_power_off = cns3xxx_power_off;
 


