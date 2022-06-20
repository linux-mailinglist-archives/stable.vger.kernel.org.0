Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6D5519E4
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbiFTNFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244819AbiFTNEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15542192B2;
        Mon, 20 Jun 2022 05:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6AE361449;
        Mon, 20 Jun 2022 12:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FA8C341C4;
        Mon, 20 Jun 2022 12:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729924;
        bh=7HXLfzXZPKUoSFxq2zbCBvTU5X7bq2SjOdG0EnWubOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSi8t9i0qB8tkZHs+DZh0eZtPwNv6myZX0RB7cLb9qmNWVMBoUDDtVjRVuGQNODB6
         W3/MExqo50blkL3NVIucNkvLERFTqhuejptvlJudb772Qj0DrmvEC/b/h5ki0RTmDF
         EdT+LzisWx4u5HgsWEeHePfZ+k1e5B9q0SLQAQ/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5.18 117/141] bus: fsl-mc-bus: fix KASAN use-after-free in fsl_mc_bus_remove()
Date:   Mon, 20 Jun 2022 14:50:55 +0200
Message-Id: <20220620124733.007864957@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 928ea98252ad75118950941683893cf904541da9 upstream.

In fsl_mc_bus_remove(), mc->root_mc_bus_dev->mc_io is passed to
fsl_destroy_mc_io(). However, mc->root_mc_bus_dev is already freed in
fsl_mc_device_remove(). Then reference to mc->root_mc_bus_dev->mc_io
triggers KASAN use-after-free. To avoid the use-after-free, keep the
reference to mc->root_mc_bus_dev->mc_io in a local variable and pass to
fsl_destroy_mc_io().

This patch needs rework to apply to kernels older than v5.15.

Fixes: f93627146f0e ("staging: fsl-mc: fix asymmetry in destroy of mc_io")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20220601105159.87752-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -1236,14 +1236,14 @@ error_cleanup_mc_io:
 static int fsl_mc_bus_remove(struct platform_device *pdev)
 {
 	struct fsl_mc *mc = platform_get_drvdata(pdev);
+	struct fsl_mc_io *mc_io;
 
 	if (!fsl_mc_is_root_dprc(&mc->root_mc_bus_dev->dev))
 		return -EINVAL;
 
+	mc_io = mc->root_mc_bus_dev->mc_io;
 	fsl_mc_device_remove(mc->root_mc_bus_dev);
-
-	fsl_destroy_mc_io(mc->root_mc_bus_dev->mc_io);
-	mc->root_mc_bus_dev->mc_io = NULL;
+	fsl_destroy_mc_io(mc_io);
 
 	bus_unregister_notifier(&fsl_mc_bus_type, &fsl_mc_nb);
 


