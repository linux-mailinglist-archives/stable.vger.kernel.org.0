Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C03866C66F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjAPQUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbjAPQTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:19:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5D72FCE9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:10:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8792660FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FA9C433D2;
        Mon, 16 Jan 2023 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885441;
        bh=EPGwsnmI2cCSq2FZmtgkZDVlbHhNuGc5wdCx//jrdwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edEJLLo8ZxVt7XuSC8XhQzbuGzzq+kDVQ4sI0odFHHqjfZe0mhXNyi3IM/JxDZ7vt
         H6U/SgLwCBJaCt2v0ubqFrSwtaeuAlYjsi5F1ujKOdlqjy7hpS3NZEKDo+pzKbr/ai
         1Yae1f5rrjxh0VPlhgVLFST0qRh4PsT1dTvoZJI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, xiongxin <xiongxin@kylinos.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/658] PM: hibernate: Fix mistake in kerneldoc comment
Date:   Mon, 16 Jan 2023 16:42:20 +0100
Message-Id: <20230116154912.034521873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 46455aa7951e..5092b8bfa1db 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1680,8 +1680,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
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



