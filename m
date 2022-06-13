Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699D5548EFB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354229AbiFMLbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353865AbiFML1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F693E0C9;
        Mon, 13 Jun 2022 03:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B3760FDB;
        Mon, 13 Jun 2022 10:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B32C34114;
        Mon, 13 Jun 2022 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116972;
        bh=MLkY1OvX2VTXtWkd4B2hKU9SxPB0F0RJYdX5ADWhvgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceCpAMcYVBLKlJJQ82aBzje9hjSXy1/y8JtvNiJ1iExB6tcK1jfbJw2a4j1K12qfe
         FvyMncfYfzqJ37iJohBuKnusZ3ShOJegd+VjjiGhjojVlcSwDNmw9UY5qFZs/AaUrb
         r7gHJorpEAqbks0lXczRTROQrXUZzb5ne8p46e2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.4 241/411] drm/nouveau/clk: Fix an incorrect NULL check on list iterator
Date:   Mon, 13 Jun 2022 12:08:34 +0200
Message-Id: <20220613094936.006726428@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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


