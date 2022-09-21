Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72055C0246
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIUPu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiIUPuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E31B9E2E9;
        Wed, 21 Sep 2022 08:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B70BF6312C;
        Wed, 21 Sep 2022 15:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9125BC433C1;
        Wed, 21 Sep 2022 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775282;
        bh=wCAQJ4eQrrJ3APQcolF3jIUnI0Y+3eKZnUZwa06m/G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuZuBt56E/Gs/r/Pd+IjwjVWUg5jnskpPtzdNdGCy+W9Nnba2Al0agFcksgyT2HNQ
         9fD4NZBj+8ebgn03lk/xwk3ITDEVerTx7H4ilvL2w4SmrVtJDSVtM3DO61a0ZnnYmB
         2qLNemZWgwHja3rP9RHshjBhR7f3TagG3/mAIuRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Frank Rowand <frank.rowand@sony.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.19 20/38] of/device: Fix up of_dma_configure_id() stub
Date:   Wed, 21 Sep 2022 17:46:04 +0200
Message-Id: <20220921153646.910874595@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

commit 40bfe7a86d84cf08ac6a8fe2f0c8bf7a43edd110 upstream.

Since the stub version of of_dma_configure_id() was added in commit
a081bd4af4ce ("of/device: Add input id to of_dma_configure()"), it has
not matched the signature of the full function, leading to build failure
reports when code using this function is built on !OF configurations.

Fixes: a081bd4af4ce ("of/device: Add input id to of_dma_configure()")
Cc: stable@vger.kernel.org
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://lore.kernel.org/r/20220824153256.1437483-1-thierry.reding@gmail.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/of_device.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -101,8 +101,9 @@ static inline struct device_node *of_cpu
 }
 
 static inline int of_dma_configure_id(struct device *dev,
-				   struct device_node *np,
-				   bool force_dma)
+				      struct device_node *np,
+				      bool force_dma,
+				      const u32 *id)
 {
 	return 0;
 }


