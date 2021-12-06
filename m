Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDFF469F1B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391393AbhLFPpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390529AbhLFPm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C13C0698C6;
        Mon,  6 Dec 2021 07:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68847B8101B;
        Mon,  6 Dec 2021 15:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEC3C34900;
        Mon,  6 Dec 2021 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804462;
        bh=uvABKF+0uhXo8hjWpBCGKhFK09bblWqlT4KGLREcB2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvqUJh5vg6c5/2RZHxXprMqdFpHDKT+8WolG4TZ9qDg7WNiEHSSgvmg+2fJwjxkLV
         bu9fRupTle5da2I/S1rnv+bl9RJGn2OG56m/UgdTKM0Hf7JAoUElcNbsK3SN9n6klu
         zW35BMZKgHcAMTOyZe8FEkFhrQ3SROp5u6aDlCzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/207] drm/msm: Fix mmap to include VM_IO and VM_DONTDUMP
Date:   Mon,  6 Dec 2021 15:56:49 +0100
Message-Id: <20211206145615.629523096@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 3466d9e217b337bf473ee629c608e53f9f3ab786 ]

In commit 510410bfc034 ("drm/msm: Implement mmap as GEM object
function") we switched to a new/cleaner method of doing things. That's
good, but we missed a little bit.

Before that commit, we used to _first_ run through the
drm_gem_mmap_obj() case where `obj->funcs->mmap()` was NULL. That meant
that we ran:

  vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
  vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
  vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);

...and _then_ we modified those mappings with our own. Now that
`obj->funcs->mmap()` is no longer NULL we don't run the default
code. It looks like the fact that the vm_flags got VM_IO / VM_DONTDUMP
was important because we're now getting crashes on Chromebooks that
use ARC++ while logging out. Specifically a crash that looks like this
(this is on a 5.10 kernel w/ relevant backports but also seen on a
5.15 kernel):

  Unable to handle kernel paging request at virtual address ffffffc008000000
  Mem abort info:
    ESR = 0x96000006
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000006
    CM = 0, WnR = 0
  swapper pgtable: 4k pages, 39-bit VAs, pgdp=000000008293d000
  [ffffffc008000000] pgd=00000001002b3003, p4d=00000001002b3003,
                     pud=00000001002b3003, pmd=0000000000000000
  Internal error: Oops: 96000006 [#1] PREEMPT SMP
  [...]
  CPU: 7 PID: 15734 Comm: crash_dump64 Tainted: G W 5.10.67 #1 [...]
  Hardware name: Qualcomm Technologies, Inc. sc7280 IDP SKU2 platform (DT)
  pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
  pc : __arch_copy_to_user+0xc0/0x30c
  lr : copyout+0xac/0x14c
  [...]
  Call trace:
   __arch_copy_to_user+0xc0/0x30c
   copy_page_to_iter+0x1a0/0x294
   process_vm_rw_core+0x240/0x408
   process_vm_rw+0x110/0x16c
   __arm64_sys_process_vm_readv+0x30/0x3c
   el0_svc_common+0xf8/0x250
   do_el0_svc+0x30/0x80
   el0_svc+0x10/0x1c
   el0_sync_handler+0x78/0x108
   el0_sync+0x184/0x1c0
  Code: f8408423 f80008c3 910020c6 36100082 (b8404423)

Let's add the two flags back in.

While we're at it, the fact that we aren't running the default means
that we _don't_ need to clear out VM_PFNMAP, so remove that and save
an instruction.

NOTE: it was confirmed that VM_IO was the important flag to fix the
problem I was seeing, but adding back VM_DONTDUMP seems like a sane
thing to do so I'm doing that too.

Fixes: 510410bfc034 ("drm/msm: Implement mmap as GEM object function")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20211110113334.1.I1687e716adb2df746da58b508db3f25423c40b27@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index bd6ec04f345e1..cb52ac01e5122 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1055,8 +1055,7 @@ static int msm_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
 
-	vma->vm_flags &= ~VM_PFNMAP;
-	vma->vm_flags |= VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vm_get_page_prot(vma->vm_flags));
 
 	return 0;
-- 
2.33.0



