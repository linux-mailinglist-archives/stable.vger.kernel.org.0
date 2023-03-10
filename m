Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230026B41E9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCJN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCJN5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CDA115DD7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B514CB822B7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C829C4339B;
        Fri, 10 Mar 2023 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456655;
        bh=NZi9uK0HBQ3YlzFMeNMn/3txjdwTn3C5yj3oQIB5MGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p26JaZCuQfO+8mV9BmMbA1Gz4AjW0jNLmT5LfMMVr6P30Jiygp99sGeqf6c/UC8cB
         WaGuONLEwAC2rSRjH8odVkYkGGfZMUnB4xn5avrcnqLPFO/6EkshuAIm9Nu4Y1YBBi
         pwU0SOHVf7PyflEFu3Z5DIj0Ex3oRev3RuDGC764=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/211] f2fs: fix to update age extent in f2fs_do_zero_range()
Date:   Fri, 10 Mar 2023 14:37:07 +0100
Message-Id: <20230310133720.168036512@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit a84153f939808102dfa10904aa0f743e734a3e1d ]

We should update age extent in f2fs_do_zero_range() like we
did in f2fs_truncate_data_blocks_range().

Fixes: 71644dff4811 ("f2fs: add block_age-based extent cache")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index cd1c6ed89d5ef..8583c098bc985 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1498,6 +1498,7 @@ static int f2fs_do_zero_range(struct dnode_of_data *dn, pgoff_t start,
 	}
 
 	f2fs_update_read_extent_cache_range(dn, start, 0, index - start);
+	f2fs_update_age_extent_cache_range(dn, start, index - start);
 
 	return ret;
 }
-- 
2.39.2



