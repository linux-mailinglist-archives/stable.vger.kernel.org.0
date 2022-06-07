Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD375406B0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347115AbiFGRha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348181AbiFGRgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:36:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B33118025;
        Tue,  7 Jun 2022 10:32:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D53FAB822B1;
        Tue,  7 Jun 2022 17:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B7AC34115;
        Tue,  7 Jun 2022 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623133;
        bh=F+Ejk3TJqvM9iJL5X57Am9LXrVwli2Qkgi0+4c09buY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCdWjxJ95gLCKrMitJ5LDMJoh+ykUrRfWxvWZSyc03eqEzQRjA+CuO9ruEMHkb0Dz
         EIQ36tHX6zAGE7R3SXngWV/5VczJ4bMrVvMj5eh3UHOy7HuN3nNP9LZBB3uDDopIDb
         qhRQ/pMrkjLGNO0JujhGTfk5cWXuTnGu9hshyEx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/452] Input: sparcspkr - fix refcount leak in bbc_beep_probe
Date:   Tue,  7 Jun 2022 19:02:44 +0200
Message-Id: <20220607164917.707030065@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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



