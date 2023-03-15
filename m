Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23E6BB360
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjCOMoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjCOMnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B92A42D5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:42:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AC4161D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D410C433EF;
        Wed, 15 Mar 2023 12:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884126;
        bh=OwmAelD3Bzx9E6LLl2bJBRLrC9hCFn1O4DDqAOBXG9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtXUj0XUp1THov7pI1z8SbSpAKtkKhL7GXvwohaKPVZFo8kTfrPG0ClJqEKBIKHbe
         8WIFhyXjvdIbh/VdoPMyvX8SlCVti+7fX7FBAmi623CWbeVHityn8f/bHp2M/PQb+a
         FSs26OREX5EiYt5Fpip9IQpX+rB5G9J7zKx0U3AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Disseldorp <ddiss@suse.de>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 116/141] watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths
Date:   Wed, 15 Mar 2023 13:13:39 +0100
Message-Id: <20230315115743.529229293@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 03e1d60e177eedbd302b77af4ea5e21b5a7ade31 ]

The watch_queue_set_size() allocation error paths return the ret value
set via the prior pipe_resize_ring() call, which will always be zero.

As a result, IOC_WATCH_QUEUE_SET_SIZE callers such as "keyctl watch"
fail to detect kernel wqueue->notes allocation failures and proceed to
KEYCTL_WATCH_KEY, with any notifications subsequently lost.

Fixes: c73be61cede58 ("pipe: Add general notification queue support")
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index a6f9bdd956c39..f10f403104e7d 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -273,6 +273,7 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	if (ret < 0)
 		goto error;
 
+	ret = -ENOMEM;
 	pages = kcalloc(sizeof(struct page *), nr_pages, GFP_KERNEL);
 	if (!pages)
 		goto error;
-- 
2.39.2



