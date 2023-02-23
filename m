Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF5D6A0A22
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbjBWNNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbjBWNNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0257857087
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B974E61705
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895BFC433EF;
        Thu, 23 Feb 2023 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157953;
        bh=YqEBlt/MwKgkt5hBPcSbLX8BvVJ17z6Du0Wacpcd00I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQDqtrXz/VtHinDfD44A/Qxul5C+ApGMPYaz9ryTOPfIEJBnWTFNwK40psbhT0A2s
         VQ301jGvi1I4MCqMJzbtYNU5vcb49QeU8VHQOYiTU4JoHR2LDp4I0blYGu8s6koH4m
         urdO3YLLMMYq7mEuUsstWMrDBBVrf/X7Ibx+wTYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, lee@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Todd Kjos <tkjos@google.com>,
        stable <stable@kernel.org>,
        Alessandro Astone <ales.astone@gmail.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 26/36] binder: Address corner cases in deferred copy and fixup
Date:   Thu, 23 Feb 2023 14:07:02 +0100
Message-Id: <20230223130430.273689449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
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

From: Alessandro Astone <ales.astone@gmail.com>

commit 2d1746e3fda0c3612143d7c06f8e1d1830c13e23 upstream.

When handling BINDER_TYPE_FDA object we are pushing a parent fixup
with a certain skip_size but no scatter-gather copy object, since
the copy is handled standalone.
If BINDER_TYPE_FDA is the last children the scatter-gather copy
loop will never stop to skip it, thus we are left with an item in
the parent fixup list. This will trigger the BUG_ON().

This is reproducible in android when playing a video.
We receive a transaction that looks like this:
    obj[0] BINDER_TYPE_PTR, parent
    obj[1] BINDER_TYPE_PTR, child
    obj[2] BINDER_TYPE_PTR, child
    obj[3] BINDER_TYPE_FDA, child

Fixes: 09184ae9b575 ("binder: defer copies of pre-patched txn data")
Acked-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alessandro Astone <ales.astone@gmail.com>
Link: https://lore.kernel.org/r/20220415120015.52684-2-ales.astone@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2331,6 +2331,7 @@ static int binder_do_deferred_txn_copies
 {
 	int ret = 0;
 	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *tmppf;
 	struct binder_ptr_fixup *pf =
 		list_first_entry_or_null(pf_head, struct binder_ptr_fixup,
 					 node);
@@ -2385,7 +2386,11 @@ static int binder_do_deferred_txn_copies
 		list_del(&sgc->node);
 		kfree(sgc);
 	}
-	BUG_ON(!list_empty(pf_head));
+	list_for_each_entry_safe(pf, tmppf, pf_head, node) {
+		BUG_ON(pf->skip_size == 0);
+		list_del(&pf->node);
+		kfree(pf);
+	}
 	BUG_ON(!list_empty(sgc_head));
 
 	return ret > 0 ? -EINVAL : ret;


