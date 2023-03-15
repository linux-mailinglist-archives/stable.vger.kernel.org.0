Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AF16BB14E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjCOM03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbjCOM0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F032792728
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71A1AB81E0A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCE1C433EF;
        Wed, 15 Mar 2023 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883069;
        bh=iuRFml4UmC9VyPY1zZPEdnGL17vD/zV0wuLQTAV2M/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/f8/Ych+RksfkbJVZXODsriqlDewrOw/y1m4HkObETVoCv0vqrY8+UlnD0tY9ItA
         QO7Yi50+yMjcn0rzL9fl75+GVICWKL5Zv0W6yhoJDRXFlmsd8WnLhLVItsbkpuyphG
         Sn9elifY0/d/r8ok6xTuDYDxibOKr0+nAebLuhCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tao Liu <taoliu828@163.com>
Subject: [PATCH 5.10 079/104] skbuff: Fix nfct leak on napi stolen
Date:   Wed, 15 Mar 2023 13:12:50 +0100
Message-Id: <20230315115735.217679084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <taoliu828@163.com>

Upstream commit [0] had fixed this issue, and backported to kernel 5.10.54.
However, nf_reset_ct() added in skb_release_head_state() instead of
napi_skb_free_stolen_head(), which lead to leakage still exist in 5.10.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984

Fixes: 570341f10ecc ("skbuff: Release nfct refcount on napi stolen or re-used skbs"))
Signed-off-by: Tao Liu <taoliu828@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c    |    1 +
 net/core/skbuff.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6111,6 +6111,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type)
 
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
+	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	skb_ext_put(skb);
 	kmem_cache_free(skbuff_head_cache, skb);
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -659,7 +659,6 @@ fastpath:
 
 void skb_release_head_state(struct sk_buff *skb)
 {
-	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	if (skb->destructor) {
 		WARN_ON(in_irq());


