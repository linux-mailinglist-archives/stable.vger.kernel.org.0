Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D0169F419
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjBVMOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjBVMMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:12:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746B02A6DB
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 04:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99035CE1CCE
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC68C433A7;
        Wed, 22 Feb 2023 12:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677067950;
        bh=+l56NUg1tWcXegCi9cdHwv19BgwFHehpTZhsVGo5qaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB2U7+1PJAgO/r1UPgedf4TCo98310i1gGJ1Gzmit4EhHrb4x4C6/u+rwGYPg4tkD
         A9nqX1tC2Wzrqaq672q13IOsz+2L/LEisJvJg9Sz+czPso+yuNhLCCFBrFuO5MdXA4
         9Eg9oHkqWKvXYl/xd1ZZVAPDSEJQLB6tqJsAHIziXGfCqeBmtnhWmw4t5DMBvFazjy
         R9kCloddwLqXgHyxshUUgFPV/23fn8+zj+yu6iJSzPThy1Hnw85Jea5lsKFXNxjiQJ
         pUNUXDwpyeagB6iO4HDPDGjOB01xurYXAJHtaLDuiTPELYWWGeQmhmPAvry2NVNqGa
         eb9e8D570pwLw==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Alessandro Astone <ales.astone@gmail.com>,
        Todd Kjos <tkjos@google.com>, stable <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH v5.15.y 4/5] binder: Address corner cases in deferred copy and fixup
Date:   Wed, 22 Feb 2023 12:12:07 +0000
Message-Id: <20230222121208.898198-5-lee@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
In-Reply-To: <20230222121208.898198-1-lee@kernel.org>
References: <20230222121208.898198-1-lee@kernel.org>
MIME-Version: 1.0
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
---
 drivers/android/binder.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index bace6034c9afd..730a89ebff972 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2331,6 +2331,7 @@ static int binder_do_deferred_txn_copies(struct binder_alloc *alloc,
 {
 	int ret = 0;
 	struct binder_sg_copy *sgc, *tmpsgc;
+	struct binder_ptr_fixup *tmppf;
 	struct binder_ptr_fixup *pf =
 		list_first_entry_or_null(pf_head, struct binder_ptr_fixup,
 					 node);
@@ -2385,7 +2386,11 @@ static int binder_do_deferred_txn_copies(struct binder_alloc *alloc,
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
-- 
2.39.2.637.g21b0678d19-goog

