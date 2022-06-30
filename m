Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88006561D0D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiF3OBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiF3OAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:00:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F88D65D66;
        Thu, 30 Jun 2022 06:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8979B82AED;
        Thu, 30 Jun 2022 13:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C337C34115;
        Thu, 30 Jun 2022 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597152;
        bh=bSIuHROVKXo/7tzzNfCHWaH1vUvYvDHMfdtjNlH6yDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvDbrdSuUo47bvwjcYggx2+GGhv51BlJazNC49WYSn1qQV+kSkvqPGshANE9/9GhL
         mXeD3VON8hOBhqg44v0IADrDxa3Ghf5pGq2rz9HkMgyTuiVSvisTbVgZ7uIhR5Lx8e
         3z3jYsJuu2kNv23CRP9DlKaZu4Mi2/Li4fwlu1hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.19 45/49] fdt: Update CRC check for rng-seed
Date:   Thu, 30 Jun 2022 15:46:58 +0200
Message-Id: <20220630133235.202121848@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
@@ -1119,6 +1119,10 @@ int __init early_init_dt_scan_chosen(uns
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1223,6 +1227,8 @@ bool __init early_init_dt_verify(void *p
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1248,8 +1254,6 @@ bool __init early_init_dt_scan(void *par
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 


