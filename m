Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029B8540805
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348781AbiFGRx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350134AbiFGRvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C9F140842;
        Tue,  7 Jun 2022 10:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD66C6137B;
        Tue,  7 Jun 2022 17:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE0EC385A5;
        Tue,  7 Jun 2022 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623535;
        bh=S7uKAmP/+PNLArLh5VL0b5w5QReWlFwAZEUTq6J66eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS2BBO1kr9ZqrKVV1Fp1/GTg/NkbSAieE5ks7iKkFiCD+771TalcjLfDqZomS/kpr
         sFdUyewkATyLuhwVD3QHJC5bevu7TH53q5QDe4bZ0SKd+bpqrhAN33EpDi22nOX+7+
         kAoNfExWM3uxkNOOqAbPNoA0190O8EupsAlxrfyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 452/452] md: bcache: check the return value of kzalloc() in detached_dev_do_request()
Date:   Tue,  7 Jun 2022 19:05:09 +0200
Message-Id: <20220607164922.040566998@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

commit 40f567bbb3b0639d2ec7d1c6ad4b1b018f80cf19 upstream.

The function kzalloc() in detached_dev_do_request() can fail, so its
return value should be checked.

Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20220527152818.27545-4-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/request.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1109,6 +1109,12 @@ static void detached_dev_do_request(stru
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddip) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		bio->bi_end_io(bio);
+		return;
+	}
+
 	ddip->d = d;
 	/* Count on the bcache device */
 	ddip->start_time = part_start_io_acct(d->disk, &ddip->part, bio);


