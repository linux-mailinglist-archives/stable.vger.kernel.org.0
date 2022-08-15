Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79F959517E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiHPE60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiHPE52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DE4BC826;
        Mon, 15 Aug 2022 13:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B186260FC4;
        Mon, 15 Aug 2022 20:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD9DC433C1;
        Mon, 15 Aug 2022 20:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596698;
        bh=nOfKq7c1vjoucNhMxCONBAKa9x7dzyly5obHXmxWhyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MppmfOHLr0vuZTa/kco1xPvcGYdmx/xJPiziLjv9xsbzPIdhVroANVpoZ2FHX7TuM
         Y6TQu+5FY9OyunOjVVVkpvORJtTPuUa+FhzmFaa1GUiOYiprTyQFDC28Q48CkQVe8u
         bGzg85yafDrFnCxu3S3JiVp29vdSW+WvlXpRIDOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 1155/1157] powerpc/kexec: Fix build failure from uninitialised variable
Date:   Mon, 15 Aug 2022 20:08:31 +0200
Message-Id: <20220815180526.750054495@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Russell Currey <ruscur@russell.cc>

commit 83ee9f23763a432a4077bf20624ee35de87bce99 upstream.

clang 14 won't build because ret is uninitialised and can be returned if
both prop and fdtprop are NULL.  Drop the ret variable and return an
error in that failure case.

Fixes: b1fc44eaa9ba ("pseries/iommu/ddw: Fix kdump to work in absence of ibm,dma-window")
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220810054331.373761-1-ruscur@russell.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/file_load_64.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -1043,17 +1043,17 @@ static int copy_property(void *fdt, int
 			 const char *propname)
 {
 	const void *prop, *fdtprop;
-	int len = 0, fdtlen = 0, ret;
+	int len = 0, fdtlen = 0;
 
 	prop = of_get_property(dn, propname, &len);
 	fdtprop = fdt_getprop(fdt, node_offset, propname, &fdtlen);
 
 	if (fdtprop && !prop)
-		ret = fdt_delprop(fdt, node_offset, propname);
+		return fdt_delprop(fdt, node_offset, propname);
 	else if (prop)
-		ret = fdt_setprop(fdt, node_offset, propname, prop, len);
-
-	return ret;
+		return fdt_setprop(fdt, node_offset, propname, prop, len);
+	else
+		return -FDT_ERR_NOTFOUND;
 }
 
 static int update_pci_dma_nodes(void *fdt, const char *dmapropname)


