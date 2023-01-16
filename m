Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2C66CB83
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjAPRPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbjAPRNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD19F25E37
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A1D261085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B17DC433EF;
        Mon, 16 Jan 2023 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888063;
        bh=L1KxcW33LNQv3HAtCHgeNVQ4jESZlz9Dnmw5PjeazPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CoKmBLB9KCax/fVY2++zmwlg3vY81IM3jKF04+Cn21y5z08FkAvu+QAYrc1UsbEaL
         cMn9djTtDPRNUyYTA9WTNRhpHxHhoUDY2fzJv2h0TUeDw684BR8QG66DGKmKEnw2Q+
         leuBFOiQJd0tMvoSqccJHWqzrxBk/ZdE90DBkXjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 386/521] dm cache: Fix UAF in destroy()
Date:   Mon, 16 Jan 2023 16:50:48 +0100
Message-Id: <20230116154904.383724551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

commit 6a459d8edbdbe7b24db42a5a9f21e6aa9e00c2aa upstream.

Dm_cache also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in destroy().

Cc: stable@vger.kernel.org
Fixes: c6b4fcbad044e ("dm: add cache target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1987,6 +1987,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 


