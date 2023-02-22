Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9569F414
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjBVMMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBVMMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1D7ABF
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 04:12:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8312861230
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 12:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DCAC433EF;
        Wed, 22 Feb 2023 12:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677067952;
        bh=he4m01Yz9J5kJbaOWgmc8hVDLanM8yU55P1nd85Mv5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSrtweo0+SQGyTqzl1e8YNrE1gVLCbgQ7qXMGWzjHKdok7fMYZmvX9AFWRY+qOT3M
         t63jgFTqy53pYsJ6eKDrxziKZGuMwTSCG4P1N/EcpSsurR+zasAMeJvG1jqXNY1ycv
         b/JuERJmrh0tAXoGcAaPGnMptM8r5K8yocorhcDfHd8UORTzx1wv3FE6rBZw7sJm2b
         IhuZ3ptaUwquKTAm4gVme7QLzr18u0dplrf2+Po9Z9ODDuhykympT1IR/3nfbPmnlo
         diDjm5pbX3YpnKGHyR//7XV2SXxCrIPT46UuxoNnaDxju73sxCTf2w3F/10C83HW2j
         crHUrlSoKBjUQ==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Alessandro Astone <ales.astone@gmail.com>,
        Todd Kjos <tkjos@google.com>, stable <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH v5.15.y 5/5] binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0
Date:   Wed, 22 Feb 2023 12:12:08 +0000
Message-Id: <20230222121208.898198-6-lee@kernel.org>
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

commit ef38de9217a04c9077629a24652689d8fdb4c6c6 upstream.

Some android userspace is sending BINDER_TYPE_FDA objects with
num_fds=0. Like the previous patch, this is reproducible when
playing a video.

Before commit 09184ae9b575 BINDER_TYPE_FDA objects with num_fds=0
were 'correctly handled', as in no fixup was performed.

After commit 09184ae9b575 we aggregate fixup and skip regions in
binder_ptr_fixup structs and distinguish between the two by using
the skip_size field: if it's 0, then it's a fixup, otherwise skip.
When processing BINDER_TYPE_FDA objects with num_fds=0 we add a
skip region of skip_size=0, and this causes issues because now
binder_do_deferred_txn_copies will think this was a fixup region.

To address that, return early from binder_translate_fd_array to
avoid adding an empty skip region.

Fixes: 09184ae9b575 ("binder: defer copies of pre-patched txn data")
Acked-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alessandro Astone <ales.astone@gmail.com>
Link: https://lore.kernel.org/r/20220415120015.52684-1-ales.astone@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/android/binder.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 730a89ebff972..c8d33c5dbe295 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2527,6 +2527,9 @@ static int binder_translate_fd_array(struct list_head *pf_head,
 	struct binder_proc *proc = thread->proc;
 	int ret;
 
+	if (fda->num_fds == 0)
+		return 0;
+
 	fd_buf_size = sizeof(u32) * fda->num_fds;
 	if (fda->num_fds >= SIZE_MAX / sizeof(u32)) {
 		binder_user_error("%d:%d got transaction with invalid number of fds (%lld)\n",
-- 
2.39.2.637.g21b0678d19-goog

