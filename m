Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08D46D49DE
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbjDCOlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjDCOly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:41:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10A417AF2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D1961EE1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACC0C433D2;
        Mon,  3 Apr 2023 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532912;
        bh=B0wK8eAwNn/v+KxzW6JU6jZ+Rl1mQPrT1K+b3YZCu4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQ+cd/jy4/hDLCdrukzKUArTmatMNn+cCgLT8vgv3g6YUX1JoJL0DpqhdQw8BT+nd
         NkKQupeMEQydDI77Z7aQB/BWPTmPOkkcvKj+VAHazMuBwqKZHrbNmLsChX97PYZ7Z8
         ghmK0/IdatTDjSAL7hDaUcggNs3PERkxRb0rYzNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 165/181] drm/i915/gem: Flush lmem contents after construction
Date:   Mon,  3 Apr 2023 16:10:00 +0200
Message-Id: <20230403140420.457463588@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@linux.intel.com>

commit d032ca43f2c80049ce5aabd3f208dc3849359497 upstream.

i915_gem_object_create_lmem_from_data() lacks the flush of the data
written to lmem to ensure the object is marked as dirty and the writes
flushed to the backing store. Once created, we can immediately release
the obj->mm.mapping caching of the vmap.

Fixes: 7acbbc7cf485 ("drm/i915/guc: put all guc objects in lmem when available")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230316165918.13074-1-nirmoy.das@intel.com
(cherry picked from commit e2ee10474ce766686e7a7496585cdfaf79e3a1bf)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_lmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
@@ -127,7 +127,8 @@ i915_gem_object_create_lmem_from_data(st
 
 	memcpy(map, data, size);
 
-	i915_gem_object_unpin_map(obj);
+	i915_gem_object_flush_map(obj);
+	__i915_gem_object_release_map(obj);
 
 	return obj;
 }


