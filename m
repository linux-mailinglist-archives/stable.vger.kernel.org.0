Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5D5868EE
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiHALzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiHALyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:54:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C093DF13;
        Mon,  1 Aug 2022 04:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23BB3B8116B;
        Mon,  1 Aug 2022 11:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CBBC433C1;
        Mon,  1 Aug 2022 11:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354640;
        bh=F9pxzWaFExZc72a2VmO0mWpFCFZ99faa32kDZsNKF9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKlgbjWxGzHyqv6H+4LAiNCSqFF0+PssKM8tcsivq8jnzOMmeNiqO/u+VLEVp3Ed6
         2JBEGbkX3IhLUOUvOT3a+WVkmGfVh1nM1eQtZ7RQ5nJ0T6F5OXplw5rkLkUdzhWfNy
         kGVBddpnIMaQfO6xCc/VefxUEKDI0MYJZGCrE6AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 05/65] nouveau/svm: Fix to migrate all requested pages
Date:   Mon,  1 Aug 2022 13:46:22 +0200
Message-Id: <20220801114133.880205502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
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
@@ -679,7 +679,11 @@ nouveau_dmem_migrate_vma(struct nouveau_
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


