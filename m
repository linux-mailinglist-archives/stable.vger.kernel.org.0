Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E466755C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbjALOVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbjALOTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D56C5DE47
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:11:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC21A6202B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA97DC433EF;
        Thu, 12 Jan 2023 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532714;
        bh=zbcuyBSW88T89OHTPDysBJT/Y7us+0DIoZ5CyH+Q2CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C98UhPpk8G9bwBWKH+8c7/htuQLwceMLmaaVLNRJiIuVrquLPeyArrFSySFaCj9bl
         SAs6eim8/1xjCWZ1tQZv1PjFLtQOeRuqQ1YczxMhl5U4n74Duj3Dcj04DCkXNXhjPG
         AH4HjW5glOHJK8Q2RXBXX9Zb4/D3ExEleGZW6OlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/783] of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()
Date:   Thu, 12 Jan 2023 14:49:29 +0100
Message-Id: <20230112135536.120512260@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit ee9d7a0e754568180a2f8ebc4aad226278a9116f ]

When kmalloc() fail to allocate memory in kasprintf(), fn_1 or fn_2 will
be NULL, and strcmp() will cause null pointer dereference.

Fixes: 2fe0e8769df9 ("of: overlay: check prevents multiple fragments touching same property")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20221211023337.592266-1-ruanjinjie@huawei.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index c8a0c0e9dec1..67b404f36e79 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -547,7 +547,7 @@ static int find_dup_cset_node_entry(struct overlay_changeset *ovcs,
 
 		fn_1 = kasprintf(GFP_KERNEL, "%pOF", ce_1->np);
 		fn_2 = kasprintf(GFP_KERNEL, "%pOF", ce_2->np);
-		node_path_match = !strcmp(fn_1, fn_2);
+		node_path_match = !fn_1 || !fn_2 || !strcmp(fn_1, fn_2);
 		kfree(fn_1);
 		kfree(fn_2);
 		if (node_path_match) {
@@ -582,7 +582,7 @@ static int find_dup_cset_prop(struct overlay_changeset *ovcs,
 
 		fn_1 = kasprintf(GFP_KERNEL, "%pOF", ce_1->np);
 		fn_2 = kasprintf(GFP_KERNEL, "%pOF", ce_2->np);
-		node_path_match = !strcmp(fn_1, fn_2);
+		node_path_match = !fn_1 || !fn_2 || !strcmp(fn_1, fn_2);
 		kfree(fn_1);
 		kfree(fn_2);
 		if (node_path_match &&
-- 
2.35.1



