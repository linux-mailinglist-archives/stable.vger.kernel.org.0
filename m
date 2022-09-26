Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3C5EA520
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238935AbiIZL6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbiIZL46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:56:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A084179EDF;
        Mon, 26 Sep 2022 03:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B88B807EC;
        Mon, 26 Sep 2022 10:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601BCC433D7;
        Mon, 26 Sep 2022 10:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189456;
        bh=IRzKGaMuCquRf/sme99rrXbn39SAxWDascXm7dwT+Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPZgnpkgvcGRmJAbYxTxPGNcWHq9b2OvNuewOvF8Km9uxrp/QcFu3s/4Xn9sqDzPM
         F3Jj7GwCCWI6aeQvTRWTzdj3J4Z814jKyzsw8Zyor+kA+dp7kIVVaK5pANKRleCJpS
         3V9ILuMCxusFBVUJ7lJK/mQhaUn3dj+5gCBvC8r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Rosin <peda@axentia.se>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 194/207] i2c: mux: harden i2c_mux_alloc() against integer overflows
Date:   Mon, 26 Sep 2022 12:13:03 +0200
Message-Id: <20220926100815.281336579@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b7af938f4379a884f15713319648a7653497a907 ]

A couple years back we went through the kernel an automatically
converted size calculations to use struct_size() instead.  The
struct_size() calculation is protected against integer overflows.

However it does not make sense to use the result from struct_size()
for additional math operations as that would negate any safeness.

Fixes: 1f3b69b6b939 ("i2c: mux: Use struct_size() in devm_kzalloc()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-mux.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 774507b54b57..313904be5f3b 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -243,9 +243,10 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
 				   int (*deselect)(struct i2c_mux_core *, u32))
 {
 	struct i2c_mux_core *muxc;
+	size_t mux_size;
 
-	muxc = devm_kzalloc(dev, struct_size(muxc, adapter, max_adapters)
-			    + sizeof_priv, GFP_KERNEL);
+	mux_size = struct_size(muxc, adapter, max_adapters);
+	muxc = devm_kzalloc(dev, size_add(mux_size, sizeof_priv), GFP_KERNEL);
 	if (!muxc)
 		return NULL;
 	if (sizeof_priv)
-- 
2.35.1



