Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73B3549202
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbiFMK46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347724AbiFMKwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F6624597;
        Mon, 13 Jun 2022 03:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 086D060AEB;
        Mon, 13 Jun 2022 10:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15609C34114;
        Mon, 13 Jun 2022 10:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116053;
        bh=lOyJjuFBdn7PwnbUrZC0mbZ8Dy3sqJhe/Zfv7N7zFXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sh2pFcTOc4knX13WU5U/XckuntpU6sDOuj85yimI6SLUESQdoQw683I/BZ57kjldF
         Cj06YG1O/Yy7mqBhBzS5NzzHpTqMnlxklrEMfZneBQfW/2mUny7C+aqKNT+BRNGHad
         AoBpjw0wP59Sm+rCNiNEY27p/b5K2ojT8Ja1smSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 4.14 115/218] drm/nouveau/clk: Fix an incorrect NULL check on list iterator
Date:   Mon, 13 Jun 2022 12:09:33 +0200
Message-Id: <20220613094924.055684325@linuxfoundation.org>
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
@@ -136,10 +136,10 @@ nvkm_cstate_find_best(struct nvkm_clk *c
 	for (cstate = start; &cstate->head != &pstate->list;
 	     cstate = list_entry(cstate->head.prev, typeof(*cstate), head)) {
 		if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
-			break;
+			return cstate;
 	}
 
-	return cstate;
+	return NULL;
 }
 
 static struct nvkm_cstate *
@@ -170,6 +170,8 @@ nvkm_cstate_prog(struct nvkm_clk *clk, s
 	if (!list_empty(&pstate->list)) {
 		cstate = nvkm_cstate_get(clk, pstate, cstatei);
 		cstate = nvkm_cstate_find_best(clk, pstate, cstate);
+		if (!cstate)
+			return -EINVAL;
 	} else {
 		cstate = &pstate->base;
 	}


