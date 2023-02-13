Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BF56949A6
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBMPAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjBMPAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34271DBB5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EBAC6111D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616CAC4339B;
        Mon, 13 Feb 2023 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300412;
        bh=SRYmsQtr7uoRmlvCMvnp3rTrwcGFeXSxqZ5WHB/ApaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zadccWl2RbXGIOwllVq2tlgxmiuS+DfcZHbQKao6nSUszTqtfW9h2GnWbAiTeINwJ
         /p7FCt2vpfr20ZNTnfBbKEPxvVYEgvCo2jTqPXOq6VvqnJ0wOFI4oIVoL4SeA05Byl
         FJa0BZVfEYVjqLzS4wI+hqvCm5oiIcCxuXlX1714=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Aravind Iddamsetty <aravind.iddamsetty@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 65/67] drm/i915: Initialize the obj flags for shmem objects
Date:   Mon, 13 Feb 2023 15:49:46 +0100
Message-Id: <20230213144735.501905723@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aravind Iddamsetty <aravind.iddamsetty@intel.com>

commit 44e4c5684fcc82d8f099656c4ea39d9571e2a8ac upstream.

Obj flags for shmem objects is not being set correctly. Fixes in setting
BO_ALLOC_USER flag which applies to shmem objs as well.

v2: Add fixes tag (Tvrtko, Matt A)

Fixes: 13d29c823738 ("drm/i915/ehl: unconditionally flush the pages on acquire")
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
[tursulin: Grouped all tags together.]
Link: https://patchwork.freedesktop.org/patch/msgid/20230203135205.4051149-1-aravind.iddamsetty@intel.com
(cherry picked from commit bca0d1d3ceeb07be45a51c0fa4d57a0ce31b6aed)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -533,7 +533,7 @@ static int shmem_object_init(struct inte
 	mapping_set_gfp_mask(mapping, mask);
 	GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
 
-	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
+	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 	obj->write_domain = I915_GEM_DOMAIN_CPU;
 	obj->read_domains = I915_GEM_DOMAIN_CPU;


