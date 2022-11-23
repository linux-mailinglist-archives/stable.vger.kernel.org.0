Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259346358DF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiKWKEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237035AbiKWKCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:02:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B779AED5ED
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66AC7B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B736EC433D6;
        Wed, 23 Nov 2022 09:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197285;
        bh=oX18axhcbNRYilLpsZvzfG5kLTzdm0anos649hNoZ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8Nc6GrrGkHjvaRg78gf/bc0N/ZypUFOxR4J2aTtb9i9PfeE+SGMGp/rm2bCiX5AE
         Xy42DptG3QVQWwaAmTEGdtxNaR3dK4+TepJe/zBcOgsI4r3nZSsg58k2TMUFDchcJo
         jnZKSbyMykDo21ZAoRjZ3qGOfv7RqNmdrFYY/API=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.0 251/314] dm bufio: Fix missing decrement of no_sleep_enabled if dm_bufio_client_create failed
Date:   Wed, 23 Nov 2022 09:51:36 +0100
Message-Id: <20221123084636.876655552@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 0dfc1f4ceae86a0d09d880ab87625c86c61ed33c upstream.

The 'no_sleep_enabled' should be decreased in error handling path
in dm_bufio_client_create() when the DM_BUFIO_CLIENT_NO_SLEEP flag
is set, otherwise static_branch_unlikely() will always return true
even if no dm_bufio_client instances have DM_BUFIO_CLIENT_NO_SLEEP
flag set.

Cc: stable@vger.kernel.org
Fixes: 3c1c875d0586 ("dm bufio: conditionally enable branching for DM_BUFIO_CLIENT_NO_SLEEP")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c5ef818ca36..bb786c39545e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1858,6 +1858,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
 	mutex_destroy(&c->lock);
+	if (c->no_sleep)
+		static_branch_dec(&no_sleep_enabled);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
-- 
2.38.1



