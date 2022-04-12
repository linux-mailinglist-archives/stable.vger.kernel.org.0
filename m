Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449F54FD888
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354821AbiDLH5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359185AbiDLHmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C36F554A1;
        Tue, 12 Apr 2022 00:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDFFD61045;
        Tue, 12 Apr 2022 07:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DB8C385A5;
        Tue, 12 Apr 2022 07:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748022;
        bh=U2/FILndl4co+BlYvc00C3mSRpRj6SmZahSvs4PQbsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCmE1VjWh8ZSjvlyNgtKa7EIKWoZY1vhdMyO0uGYU6bewvbaMFPrNQvZQQfYDiw4A
         GCMEJwfKVDLg985EjXCYO5YtBPTjdynkoKgNGWZrQIU+omzfuO9Px+cFMWjbJvqGXl
         HE0GlVQT6jBVgPhaqi7eivw9RSgV4V8eCHe8hKvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Douglas Miller <doug.miller@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.17 292/343] RDMA/hfi1: Fix use-after-free bug for mm struct
Date:   Tue, 12 Apr 2022 08:31:50 +0200
Message-Id: <20220412062959.756103757@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Miller <doug.miller@cornelisnetworks.com>

commit 2bbac98d0930e8161b1957dc0ec99de39ade1b3c upstream.

Under certain conditions, such as MPI_Abort, the hfi1 cleanup code may
represent the last reference held on the task mm.
hfi1_mmu_rb_unregister() then drops the last reference and the mm is freed
before the final use in hfi1_release_user_pages().  A new task may
allocate the mm structure while it is still being used, resulting in
problems. One manifestation is corruption of the mmap_sem counter leading
to a hang in down_write().  Another is corruption of an mm struct that is
in use by another task.

Fixes: 3d2a9d642512 ("IB/hfi1: Ensure correct mm is used at all times")
Link: https://lore.kernel.org/r/20220408133523.122165.72975.stgit@awfm-01.cornelisnetworks.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Douglas Miller <doug.miller@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -80,6 +80,9 @@ void hfi1_mmu_rb_unregister(struct mmu_r
 	unsigned long flags;
 	struct list_head del_list;
 
+	/* Prevent freeing of mm until we are completely finished. */
+	mmgrab(handler->mn.mm);
+
 	/* Unregister first so we don't get any more notifications. */
 	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
 
@@ -102,6 +105,9 @@ void hfi1_mmu_rb_unregister(struct mmu_r
 
 	do_remove(handler, &del_list);
 
+	/* Now the mm may be freed. */
+	mmdrop(handler->mn.mm);
+
 	kfree(handler);
 }
 


