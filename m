Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD25665EC81
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjAENKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjAENJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:09:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE915E64B
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DDC1ECE1ADB
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A32C433D2;
        Thu,  5 Jan 2023 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672924180;
        bh=Tddixb9zTHqoZsXBf+5yYqZC0IQ60VKsjgLShdTxM68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07eADQWeC0zA+Fca3aBj3BZ4JK6g9afXNeTKuQVlNdOaqPpjQHO9CFckaIwBulPiN
         Kb7gsL/wCR9f6gzHHH6OJP1ZoQo7Nk++FmgDuum+5PR0A8y6BE6b8CIgUSzFjrVfq0
         MAPMmdeMCE5rbsbp3BuNadzbzgumXV8Qnraqwq8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.9 232/251] dm cache: Fix UAF in destroy()
Date:   Thu,  5 Jan 2023 13:56:09 +0100
Message-Id: <20230105125345.496238847@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
@@ -2321,6 +2321,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 


