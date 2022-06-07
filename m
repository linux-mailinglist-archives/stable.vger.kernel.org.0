Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8A0541C80
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382334AbiFGWDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382437AbiFGWCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8B924F799;
        Tue,  7 Jun 2022 12:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95180617DA;
        Tue,  7 Jun 2022 19:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D59C34115;
        Tue,  7 Jun 2022 19:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629272;
        bh=F+Ejk3TJqvM9iJL5X57Am9LXrVwli2Qkgi0+4c09buY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emSbu9NKAwLEWGI8kU9fBYnhVb5SGKSYdjzBJXxxXKX/qaHfsRCN35JH+ZVALTgnk
         3LAO9cO/l66GiplBom+sVCtsMK0TCL2PyBp4flcGiaMCHBTRY2mN/fbCtG1JQzucQT
         hkZ5qF4LvguxVfC/K4Xy2NIk42F2DFWwBPapn2mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 629/879] Input: sparcspkr - fix refcount leak in bbc_beep_probe
Date:   Tue,  7 Jun 2022 19:02:27 +0200
Message-Id: <20220607165021.107265229@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c8994b30d71d64d5dcc9bc0edbfdf367171aa96f ]

of_find_node_by_path() calls of_find_node_opts_by_path(),
which returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 9c1a5077fdca ("input: Rewrite sparcspkr device probing.")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220516081018.42728-1-linmq006@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/sparcspkr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index fe43e5557ed7..cdcb7737c46a 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -205,6 +205,7 @@ static int bbc_beep_probe(struct platform_device *op)
 
 	info = &state->u.bbc;
 	info->clock_freq = of_getintprop_default(dp, "clock-frequency", 0);
+	of_node_put(dp);
 	if (!info->clock_freq)
 		goto out_free;
 
-- 
2.35.1



