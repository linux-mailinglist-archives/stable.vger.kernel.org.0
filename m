Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305355407CB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiFGRwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349037AbiFGRu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCA1139AE4;
        Tue,  7 Jun 2022 10:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FBA61529;
        Tue,  7 Jun 2022 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F02C385A5;
        Tue,  7 Jun 2022 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623448;
        bh=MLkY1OvX2VTXtWkd4B2hKU9SxPB0F0RJYdX5ADWhvgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMVsQ/u6i8Rn/k4yYXeOySuJ4G29v9mVVFZ4KtISPfvbQYX6MWfFwazRmGPQhZrN/
         TK0SuJSaF0H+I0n0SCOO+1XLaiq647zxANGVe/KJPdKE59tS/p0M5S20J6LOVu54Ic
         0DZu7U7oDKOYx/WEl8lPp5GV4pVdy7oZBjWx8p1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 380/452] drm/nouveau/clk: Fix an incorrect NULL check on list iterator
Date:   Tue,  7 Jun 2022 19:03:57 +0200
Message-Id: <20220607164919.889007817@linuxfoundation.org>
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 1c3b2a27def609473ed13b1cd668cb10deab49b4 upstream.

The bug is here:
	if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
		return cstate;

The list iterator value 'cstate' will *always* be set and non-NULL
by list_for_each_entry_from_reverse(), so it is incorrect to assume
that the iterator value will be unchanged if the list is empty or no
element is found (In fact, it will be a bogus pointer to an invalid
structure object containing the HEAD). Also it missed a NULL check
at callsite and may lead to invalid memory access after that.

To fix this bug, just return 'encoder' when found, otherwise return
NULL. And add the NULL check.

Cc: stable@vger.kernel.org
Fixes: 1f7f3d91ad38a ("drm/nouveau/clk: Respect voltage limits in nvkm_cstate_prog")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220327075824.11806-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
@@ -135,10 +135,10 @@ nvkm_cstate_find_best(struct nvkm_clk *c
 
 	list_for_each_entry_from_reverse(cstate, &pstate->list, head) {
 		if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
-			break;
+			return cstate;
 	}
 
-	return cstate;
+	return NULL;
 }
 
 static struct nvkm_cstate *
@@ -169,6 +169,8 @@ nvkm_cstate_prog(struct nvkm_clk *clk, s
 	if (!list_empty(&pstate->list)) {
 		cstate = nvkm_cstate_get(clk, pstate, cstatei);
 		cstate = nvkm_cstate_find_best(clk, pstate, cstate);
+		if (!cstate)
+			return -EINVAL;
 	} else {
 		cstate = &pstate->base;
 	}


