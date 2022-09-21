Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554275C0292
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIUPyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiIUPwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6E6AE74;
        Wed, 21 Sep 2022 08:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D7D630B2;
        Wed, 21 Sep 2022 15:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0237C433D6;
        Wed, 21 Sep 2022 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775327;
        bh=wCAQJ4eQrrJ3APQcolF3jIUnI0Y+3eKZnUZwa06m/G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSNqUb1c1c61QDu72FLrM/AQIakpoR1xk4DsVXsMdkcX8RWr0+wI1Oot+bwvafiKs
         MsNpsmaTU3r6Wb4XsuKCMXMySu/0JtTOrHtAwe5d1RsSuLXuCD3Ids6UD9Hu2yXkCa
         DBSD4X5U0Pn6aDeKRw4lejOmacXSOKPzFqIOUsoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Frank Rowand <frank.rowand@sony.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 16/45] of/device: Fix up of_dma_configure_id() stub
Date:   Wed, 21 Sep 2022 17:46:06 +0200
Message-Id: <20220921153647.417919336@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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


