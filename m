Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90E60A9A0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiJXNXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiJXNWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B26B13F8F;
        Mon, 24 Oct 2022 05:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD252612BC;
        Mon, 24 Oct 2022 12:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD599C433D7;
        Mon, 24 Oct 2022 12:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614400;
        bh=1QUJDNqcFFRSgqgvnf6wISDMsBWhPp8lS7GZcNtc4uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMuGKLUKnbLZzC1Hyp84e4OHB1hSz82Ddr22JgCqKvDziyLQum27tJqWg7QJxzGcD
         96tn4Rb9YrPyF3JfV4R3pRIWuQkR6YE5ol/szqzckmaMKY0T8KqOruAfAyePY0zU0y
         lPzsg1mWRYt3ShZo/Kg5B25g2pihtCC3Dy64XLmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/390] fsi: core: Check error number after calling ida_simple_get
Date:   Mon, 24 Oct 2022 13:30:43 +0200
Message-Id: <20221024113033.316461841@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 35af9fb49bc5c6d61ef70b501c3a56fe161cce3e ]

If allocation fails, the ida_simple_get() will return error number.
So master->idx could be error number and be used in dev_set_name().
Therefore, it should be better to check it and return error if fails,
like the ida_simple_get() in __fsi_get_new_minor().

Fixes: 09aecfab93b8 ("drivers/fsi: Add fsi master definition")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20220111073411.614138-1-jiasheng@iscas.ac.cn
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/fsi/fsi-core.c b/drivers/fsi/fsi-core.c
index 59ddc9fd5bca..92e6eebd1851 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -1309,6 +1309,9 @@ int fsi_master_register(struct fsi_master *master)
 
 	mutex_init(&master->scan_lock);
 	master->idx = ida_simple_get(&master_ida, 0, INT_MAX, GFP_KERNEL);
+	if (master->idx < 0)
+		return master->idx;
+
 	dev_set_name(&master->dev, "fsi%d", master->idx);
 	master->dev.class = &fsi_master_class;
 
-- 
2.35.1



