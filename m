Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC42664A39
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbjAJSb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbjAJSaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD908D3A7
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B0D761866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47CC433EF;
        Tue, 10 Jan 2023 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375125;
        bh=E+k1Oi8qB3JWMnB0Rv0gwrVg80L4EiYApzwOQySh1Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8QdTsxeMsvwdkjJM4BYXFtNpzGslPzUgMBqF17lKi/Ohml9SY3e9WFrehIK8JFzm
         wMr0Pb/GXm5Kr7w+7vEtfuVpzKDSw3r2WRPF1AbTtYtH5xpkKNWkTxtAUH0yfmdbhM
         CC1nMMgiHK7WyQZB5TjidEwGJBSiIbIiMhVDppY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 086/290] dm integrity: Fix UAF in dm_integrity_dtr()
Date:   Tue, 10 Jan 2023 19:02:58 +0100
Message-Id: <20230110180034.576429342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Luo Meng <luomeng12@huawei.com>

commit f50cb2cbabd6c4a60add93d72451728f86e4791c upstream.

Dm_integrity also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in dm_integrity_dtr().

Cc: stable@vger.kernel.org
Fixes: 7eada909bfd7a ("dm: add integrity target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4539,6 +4539,8 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)


