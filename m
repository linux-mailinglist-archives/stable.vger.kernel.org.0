Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C485365EB60
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjAEM7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjAEM7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:59:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B025A8AC
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76A98B81AD4
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD19C433D2;
        Thu,  5 Jan 2023 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923521;
        bh=QACIhB/Dh4yjVnjpjUaa1Crn7thIWMZO8SlBO2M7y2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+cAChtTX+jze9bEcTOTSyNcV4qtVxPfpQ9qRt8RUjEZgdORfb+J9kjzaAglakbWK
         wJDW8Z1D5UzwrgnvNRcB/gW6vGtEaXViwQt3Us/Onxs4pyrB5F75f6WqEsQuflqudN
         THdUduT4LxgkA8NCmU6VD8Orw1u/en4SvtsDDzaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, xiongxin <xiongxin@kylinos.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 029/251] PM: hibernate: Fix mistake in kerneldoc comment
Date:   Thu,  5 Jan 2023 13:52:46 +0100
Message-Id: <20230105125336.094397655@linuxfoundation.org>
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

From: xiongxin <xiongxin@kylinos.cn>

[ Upstream commit 6e5d7300cbe7c3541bc31f16db3e9266e6027b4b ]

The actual maximum image size formula in hibernate_preallocate_memory()
is as follows:

max_size = (count - (size + PAGES_FOR_IO)) / 2
	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);

but the one in the kerneldoc comment of the function is different and
incorrect.

Fixes: ddeb64870810 ("PM / Hibernate: Add sysfs knob to control size of memory for drivers")
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
[ rjw: Subject and changelog rewrite ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/snapshot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 5dfac92521fa..b02850cfc8ee 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1677,8 +1677,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
  * /sys/power/reserved_size, respectively).  To make this happen, we compute the
  * total number of available page frames and allocate at least
  *
- * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
- *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
+ * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
+ *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
  *
  * of them, which corresponds to the maximum size of a hibernation image.
  *
-- 
2.35.1



