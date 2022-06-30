Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA82561BD6
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbiF3Nth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbiF3Nss (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA730F5B;
        Thu, 30 Jun 2022 06:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2285861FD0;
        Thu, 30 Jun 2022 13:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28656C34115;
        Thu, 30 Jun 2022 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596917;
        bh=Ppv1uKMDvu98Ab/kKeOFuUXMXKMeALLEju0l3eEAOwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmA/84SGKXQTqe/2IbdUuZWMDy+97t1d/qDXMUbdkWB7RZfWA46GKUomNLvZ+OAoe
         3B37CqqaYS6Sf5xeiphRLiPDjkIpf+9HgdVovhrgGmuaUCknvcMtVqpFIPMhZufvk9
         W3R4Ji1XMthAnx+acm//3XIVEWULocf6f2Rho8lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.9 27/29] fdt: Update CRC check for rng-seed
Date:   Thu, 30 Jun 2022 15:46:27 +0200
Message-Id: <20220630133232.001721917@linuxfoundation.org>
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

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit dd753d961c4844a39f947be115b3d81e10376ee5 upstream.

Commit 428826f5358c ("fdt: add support for rng-seed") moves of_fdt_crc32
from early_init_dt_verify() to early_init_dt_scan() since
early_init_dt_scan_chosen() may modify fdt to erase rng-seed.

However, arm and some other arch won't call early_init_dt_scan(), they
call early_init_dt_verify() then early_init_dt_scan_nodes().

Restore of_fdt_crc32 to early_init_dt_verify() then update it in
early_init_dt_scan_chosen() if fdt if updated.

Fixes: 428826f5358c ("fdt: add support for rng-seed")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/fdt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1110,6 +1110,10 @@ int __init early_init_dt_scan_chosen(uns
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1213,6 +1217,8 @@ bool __init early_init_dt_verify(void *p
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1238,8 +1244,6 @@ bool __init early_init_dt_scan(void *par
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 


