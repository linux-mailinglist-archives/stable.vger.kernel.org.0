Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DE9561BE7
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiF3Nsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbiF3Nsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256F5100C;
        Thu, 30 Jun 2022 06:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4539D61FF6;
        Thu, 30 Jun 2022 13:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F329C34115;
        Thu, 30 Jun 2022 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596900;
        bh=l+0t1T7UVgnnl52KigGaMI+Ya57FIMlUgLltqt/jz/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KL7bzW3CyG0ZItErRGGteoIautfkHs8bf5qmg0TWZNITRKHZ0osY82Oc0TY0rarZE
         as7UAP3sM/AOzI2XpIm5l0DEt8U6EWjxam15rUbbVVDZGTNJshUCe+sKb5xMtEPVM+
         gK7r183yTObTmXYRkVvj415OIl2XG/TO4aTuCvB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.9 21/29] ARM: Fix refcount leak in axxia_boot_secondary
Date:   Thu, 30 Jun 2022 15:46:21 +0200
Message-Id: <20220630133231.825078988@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
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

commit 7c7ff68daa93d8c4cdea482da4f2429c0398fcde upstream.

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 1d22924e1c4e ("ARM: Add platform support for LSI AXM55xx SoC")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220601090548.47616-1-linmq006@gmail.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-axxia/platsmp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-axxia/platsmp.c
+++ b/arch/arm/mach-axxia/platsmp.c
@@ -42,6 +42,7 @@ static int axxia_boot_secondary(unsigned
 		return -ENOENT;
 
 	syscon = of_iomap(syscon_np, 0);
+	of_node_put(syscon_np);
 	if (!syscon)
 		return -ENOMEM;
 


