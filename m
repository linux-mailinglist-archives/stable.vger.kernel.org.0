Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012875869F8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiHAMJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiHAMJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:09:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919AD474DD;
        Mon,  1 Aug 2022 04:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C2D1B81163;
        Mon,  1 Aug 2022 11:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B36DC433C1;
        Mon,  1 Aug 2022 11:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354969;
        bh=IsG/U4fQGUPODCf0APL5nFn0a24AgCa9PiGN+MZTaxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJF3C9bXFocTdWeNBCnzskm5NX4HvqlmysbYN94MJrSl2TMGzRc0EpygopNUClZXl
         7oRsbxAyyXeOvgVvqSFY5M395Yg/cqkrMb/uwyEeD8faWenVml6L42/uv1kmN129pn
         vcmiurik9eTVaG54IZeDMkAp+5ihT9yKDwdQMN6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.18 16/88] nouveau/svm: Fix to migrate all requested pages
Date:   Mon,  1 Aug 2022 13:46:30 +0200
Message-Id: <20220801114138.794214738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit 66cee9097e2b74ff3c8cc040ce5717c521a0c3fa upstream.

Users may request that pages from an OpenCL SVM allocation be migrated
to the GPU with clEnqueueSVMMigrateMem(). In Nouveau this will call into
nouveau_dmem_migrate_vma() to do the migration. If the total range to be
migrated exceeds SG_MAX_SINGLE_ALLOC the pages will be migrated in
chunks of size SG_MAX_SINGLE_ALLOC. However a typo in updating the
starting address means that only the first chunk will get migrated.

Fix the calculation so that the entire range will get migrated if
possible.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: e3d8b0890469 ("drm/nouveau/svm: map pages after migration")
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220720062745.960701-1-apopple@nvidia.com
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -680,7 +680,11 @@ nouveau_dmem_migrate_vma(struct nouveau_
 		goto out_free_dma;
 
 	for (i = 0; i < npages; i += max) {
-		args.end = start + (max << PAGE_SHIFT);
+		if (args.start + (max << PAGE_SHIFT) > end)
+			args.end = end;
+		else
+			args.end = args.start + (max << PAGE_SHIFT);
+
 		ret = migrate_vma_setup(&args);
 		if (ret)
 			goto out_free_pfns;


