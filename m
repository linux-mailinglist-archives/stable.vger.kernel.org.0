Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF45576286
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 15:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiGONIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 09:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiGONIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 09:08:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CAC4330C
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 06:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46AB62389
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931FFC34115;
        Fri, 15 Jul 2022 13:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657890479;
        bh=tKPoGbPM/QAbQPwvlOB1mHl4zEA9zPDGxCWV2N/ISeo=;
        h=Subject:To:Cc:From:Date:From;
        b=tVTkiA6zcEeU6SWHy1hzhKZLGcNj659oSbVrsugNgKTNAdYBk6ygHBOME+fgvSCz6
         CckF5EHsqJKfkktgY5InKbRtqEn24R89z6uO2Ckgwg5JSQX6ZG7n9UMDvuPuUsogE+
         BGn/FE3wP1MdB596OB5AL74DjdNLAvSkV7fVLLLk=
Subject: FAILED: patch "[PATCH] fs/remap: constrain dedupe of EOF blocks" failed to apply to 5.4-stable tree
To:     dchinner@redhat.com, ansgar.loesser@tu-darmstadt.de,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jul 2022 15:07:56 +0200
Message-ID: <1657890476193144@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5750676b64a561f7ec920d7c6ba130fc9c7378f3 Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Wed, 13 Jul 2022 17:49:15 +1000
Subject: [PATCH] fs/remap: constrain dedupe of EOF blocks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If dedupe of an EOF block is not constrainted to match against only
other EOF blocks with the same EOF offset into the block, it can
match against any other block that has the same matching initial
bytes in it, even if the bytes beyond EOF in the source file do
not match.

Fix this by constraining the EOF block matching to only match
against other EOF blocks that have identical EOF offsets and data.
This allows "whole file dedupe" to continue to work without allowing
eof blocks to randomly match against partial full blocks with the
same data.

Reported-by: Ansgar Lößer <ansgar.loesser@tu-darmstadt.de>
Fixes: 1383a7ed6749 ("vfs: check file ranges before cloning files")
Link: https://lore.kernel.org/linux-fsdevel/a7c93559-4ba1-df2f-7a85-55a143696405@tu-darmstadt.de/
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/remap_range.c b/fs/remap_range.c
index e112b5424cdb..881a306ee247 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -71,7 +71,8 @@ static int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	 * Otherwise, make sure the count is also block-aligned, having
 	 * already confirmed the starting offsets' block alignment.
 	 */
-	if (pos_in + count == size_in) {
+	if (pos_in + count == size_in &&
+	    (!(remap_flags & REMAP_FILE_DEDUP) || pos_out + count == size_out)) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
 		if (!IS_ALIGNED(count, bs))

