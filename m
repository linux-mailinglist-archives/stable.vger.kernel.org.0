Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B07A643452
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiLETod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiLEToQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:44:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E702B25A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:41:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5877361314
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B51C433D6;
        Mon,  5 Dec 2022 19:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269291;
        bh=9t1OrdFXHC8DSo4BD5AMyx3VOcYMZlxMqezbaZzJS78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EceFemGuBcfE1lw7OMd3EO2OTkirreuqz6wy0GczERKyOdQTIuWYHsPucp+83DRsy
         oqj+/gNTYLABFzooDqvq3hdep3ENKYHxrEhSLGGTjw/blen8V25GMQr3fmZh7mG+Ui
         Pe2uawKu+edhGX59dthZG/GcZFZIamlgWI9TkTUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Todd Kjos <tkjos@google.com>,
        stable <stable@kernel.org>,
        Alessandro Astone <ales.astone@gmail.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 073/153] binder: Address corner cases in deferred copy and fixup
Date:   Mon,  5 Dec 2022 20:09:57 +0100
Message-Id: <20221205190810.815729046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2698,6 +2698,7 @@ static int binder_do_deferred_txn_copies
 {
 	int ret = 0;
 	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *tmppf;
 	struct binder_ptr_fixup *pf =
 		list_first_entry_or_null(pf_head, struct binder_ptr_fixup,
 					 node);
@@ -2752,7 +2753,11 @@ static int binder_do_deferred_txn_copies
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


