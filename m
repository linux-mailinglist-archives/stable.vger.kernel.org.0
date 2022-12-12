Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3150C64A182
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiLLNlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiLLNkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:40:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A02213FA7
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1BB6106F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD76C433D2;
        Mon, 12 Dec 2022 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852411;
        bh=B1gfcc84FS2VJ5AFHOS0RseO8df/MKFYVVfckAjjc7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLsgHZXkSMo59uLguwR1bMA9GT0lp+CGI2Lcb3xgW7RaYgRgVXOifvXpsBdWYC7sn
         Jvhweb59apJOEdA6wvBBkqb1LU7ln5Z9eWWQIcpVaOsFSxaUmoL3QsR0mjjUZpO4RJ
         jUoCjjLMD657+eqj31XTgeZDrUBIJyREhb91uKxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.0 075/157] drm/shmem-helper: Remove errant put in error path
Date:   Mon, 12 Dec 2022 14:17:03 +0100
Message-Id: <20221212130937.714827012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

commit 24013314be6ee4ee456114a671e9fa3461323de8 upstream.

drm_gem_shmem_mmap() doesn't own this reference, resulting in the GEM
object getting prematurely freed leading to a later use-after-free.

Link: https://syzkaller.appspot.com/bug?extid=c8ae65286134dd1b800d
Reported-by: syzbot+c8ae65286134dd1b800d@syzkaller.appspotmail.com
Fixes: 2194a63a818d ("drm: Add library for shmem backed GEM objects")
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221130185748.357410-2-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -622,10 +622,8 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);
-	if (ret) {
-		drm_gem_vm_close(vma);
+	if (ret)
 		return ret;
-	}
 
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);


