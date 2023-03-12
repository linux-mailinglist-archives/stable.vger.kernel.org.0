Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8556B65D3
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 13:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCLMFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCLMFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 08:05:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF52212A;
        Sun, 12 Mar 2023 05:05:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4219960E9F;
        Sun, 12 Mar 2023 12:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5791CC433D2;
        Sun, 12 Mar 2023 12:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678622736;
        bh=oKN5Z54f3+6zfJE+zzdxA36xTB8hfAgEC5GmVv/2Fio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+ptG7hhF2cM4XdL71UNPqRg5QphSUdpf7i1tL0rW2wpRkNNrcCygSh65w8YRBlOG
         cCKsBf8VELb4SPkiME+N/AmH1C82fADgoTpwsZPkjJoLcA8TXsfybxzE5IosfOqru7
         FQosJNtJs0fOZuJkn79nbG6MvTOPobyQHjwD3ggI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.101
Date:   Sun, 12 Mar 2023 13:05:25 +0100
Message-Id: <1678622725100147@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167862272511368@kroah.com>
References: <167862272511368@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index ef2defa6bce2..2db3f373b81e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 100
+SUBLEVEL = 101
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 6499f8ba953a..7c4d5158e03b 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -51,7 +51,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915_gem_ww_ctx *ww)
 	if (unlikely(ret))
 		goto err_unpin;
 
-	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
+	if (i915_vma_is_map_and_fenceable(vma)) {
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	} else {
 		int type = i915_coherent_map_type(vma->vm->i915, vma->obj, false);
@@ -96,7 +96,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 		return;
 
 	i915_vma_unset_ggtt_write(vma);
-	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
+	if (i915_vma_is_map_and_fenceable(vma))
 		i915_vma_unpin_iomap(vma);
 	else
 		i915_gem_object_unpin_map(vma->obj);
