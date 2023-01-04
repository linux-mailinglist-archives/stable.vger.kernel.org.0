Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D8D65D4D1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjADOAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjADOAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD9627B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 062166172D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FEEC433EF;
        Wed,  4 Jan 2023 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672840801;
        bh=yRQMdAdC9bh2FSx/1+EAXShUgNC7wTa53JD/AWtxlz8=;
        h=Subject:To:Cc:From:Date:From;
        b=G/6Qosniwj4PbtZwqpIc0qyuUrSNOwoC/LBXGV7XfXy3fQqVEGlob9WzJO06MkrLT
         Z6H/ij7eUCe2YsJteCfwKbApcH2t6dI2HqkkR2L/1sMyAxsF/vyRL+p0zA5fTciLyp
         DXoM2TUjsxuckF4l0KtaSDQJXHNndicxMBNVHtEo=
Subject: FAILED: patch "[PATCH] dm integrity: Fix UAF in dm_integrity_dtr()" failed to apply to 4.14-stable tree
To:     luomeng12@huawei.com, snitzer@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:59:49 +0100
Message-ID: <167284078911323@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f50cb2cbabd6 ("dm integrity: Fix UAF in dm_integrity_dtr()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f50cb2cbabd6c4a60add93d72451728f86e4791c Mon Sep 17 00:00:00 2001
From: Luo Meng <luomeng12@huawei.com>
Date: Tue, 29 Nov 2022 10:48:50 +0800
Subject: [PATCH] dm integrity: Fix UAF in dm_integrity_dtr()

Dm_integrity also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in dm_integrity_dtr().

Cc: stable@vger.kernel.org
Fixes: 7eada909bfd7a ("dm: add integrity target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e97e9f97456d..1388ee35571e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4558,6 +4558,8 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)

