Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F207548EC3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345166AbiFMKuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344335AbiFMKrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE8E2C104;
        Mon, 13 Jun 2022 03:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E3160EF5;
        Mon, 13 Jun 2022 10:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD551C34114;
        Mon, 13 Jun 2022 10:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115957;
        bh=tx6HgN386WLwB2WB8TgNOq4Nshf8cgFom7qnPkHSvdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JCmMswsHcLnWrUtNU3kqZingkDXSV6a4LtqDJ05Gdi5UAm9KS9K6WCHtQzISUleM
         LbBSmZ1A/xUhPldvpK/1p0eix5N5pcNpZCUCjPzskLnsRznvcJOS/x+I9RW+AIYbSC
         c5CydIzJNWtxpme2DSmZ5V9fstNUeZjLuqRxJp0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/218] Input: sparcspkr - fix refcount leak in bbc_beep_probe
Date:   Mon, 13 Jun 2022 12:09:11 +0200
Message-Id: <20220613094923.364745016@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index 4a5afc7fe96e..f6e1f38267d9 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -204,6 +204,7 @@ static int bbc_beep_probe(struct platform_device *op)
 
 	info = &state->u.bbc;
 	info->clock_freq = of_getintprop_default(dp, "clock-frequency", 0);
+	of_node_put(dp);
 	if (!info->clock_freq)
 		goto out_free;
 
-- 
2.35.1



