Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29E166C744
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjAPQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjAPQ3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:29:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABB62DE6C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BDF9B80E93
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D821C433D2;
        Mon, 16 Jan 2023 16:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885835;
        bh=KfU0Kazit8cteBcOEpfvjJ8at7EbWUVSm/YHTshKfjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nk5wpCmMIVbVEfiMiUxqUCXvaV5x1/dSrmktS+o1RvBCC8+Yxye15lOiQUr/pS1Y2
         /gT/j73+eHM+/r5IyPPxCE+XcPxnq6dfSowF7IDgJbNAt/z1pdie+OwKmWujcqSY5q
         7L/5DuFce2iZsMzkCEOZa5a2HHBlFhgD2NquiVvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/658] media: c8sectpfe: Add of_node_put() when breaking out of loop
Date:   Mon, 16 Jan 2023 16:44:50 +0100
Message-Id: <20230116154918.674750757@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 63ff05a1ad242a5a0f897921c87b70d601bda59c ]

In configure_channels(), we should call of_node_put() when breaking
out of for_each_child_of_node() which will automatically increase
and decrease the refcount.

Fixes: c5f5d0f99794 ("[media] c8sectpfe: STiH407/10 Linux DVB demux support")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 5baada4f65e5..69070b706831 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -939,6 +939,7 @@ static int configure_channels(struct c8sectpfei *fei)
 		if (ret) {
 			dev_err(fei->dev,
 				"configure_memdma_and_inputblock failed\n");
+			of_node_put(child);
 			goto err_unmap;
 		}
 		index++;
-- 
2.35.1



