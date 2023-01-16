Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B437166C7AC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjAPQdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbjAPQcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3408D301BD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C521C61041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC832C433D2;
        Mon, 16 Jan 2023 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886051;
        bh=SYgF3rKzZyzmEk2atQfWeHtkER+qJ2fXSg8mfd4dOeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zGzOj5f/XHYr33d/gND2HlvgEceDkq3T1LqQPW5+JeMQm7XNif4PYrfGwDas+7NP
         zxpKknxMhqswNxWojX02bcHbc7pSUMTyWD1ORgDLj1t3BoIGB63SihiV3X7TyQxDVk
         oHUbdJ7w9fnJwCy4dj2w5HEVBrsItbFMC4RKmjsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 254/658] crypto: ccree - Make cc_debugfs_global_fini() available for module init function
Date:   Mon, 16 Jan 2023 16:45:42 +0100
Message-Id: <20230116154921.182570533@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 8e96729fc26c8967db45a3fb7a60387619f77a22 ]

ccree_init() calls cc_debugfs_global_fini(), the former is an init
function and the latter an exit function though.

A modular build emits:

	WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in reference: init_module (section: .init.text) -> cc_debugfs_global_fini (section: .exit.text)

(with CONFIG_DEBUG_SECTION_MISMATCH=y).

Fixes: 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 566999738698..47077dd77f5d 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -59,7 +59,7 @@ void __init cc_debugfs_global_init(void)
 	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
 }
 
-void __exit cc_debugfs_global_fini(void)
+void cc_debugfs_global_fini(void)
 {
 	debugfs_remove(cc_debugfs_dir);
 }
-- 
2.35.1



