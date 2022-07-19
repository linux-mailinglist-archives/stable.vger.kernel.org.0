Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DFC579D42
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiGSMuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241700AbiGSMsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:48:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2188D5DC;
        Tue, 19 Jul 2022 05:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3DD96177F;
        Tue, 19 Jul 2022 12:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF202C341C6;
        Tue, 19 Jul 2022 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233151;
        bh=PEuV/4o35jeAEzG8xHkh/SJRBVMvdGbRaqzCgxIJ/OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBTSmiDGOCBShHVwj2wsV40YBeTo+ggdJODGwV7pEZJt9tOjbOrVjynEtpQzNFRLR
         G0qM8XwjGV3n5g2lNSSvGDyhV6qZMpFAN7l1S2CqNKH7e2lakJTn+gXG5U+N1T1sNz
         a1V1/vnAY800v3Np+vzVGEzpoMXxiPBYbF3O0f8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.18 023/231] ARM: 9213/1: Print message about disabled Spectre workarounds only once
Date:   Tue, 19 Jul 2022 13:51:48 +0200
Message-Id: <20220719114715.954895250@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit e4ced82deb5fb17222fb82e092c3f8311955b585 upstream.

Print the message about disabled Spectre workarounds only once. The
message is printed each time CPU goes out from idling state on NVIDIA
Tegra boards, causing storm in KMSG that makes system unusable.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/proc-v7-bugs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -108,8 +108,7 @@ static unsigned int spectre_v2_install_w
 #else
 static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
-	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n",
-		smp_processor_id());
+	pr_info_once("Spectre V2: workarounds disabled by configuration\n");
 
 	return SPECTRE_VULNERABLE;
 }


