Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B776043FF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJSLz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiJSLyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:54:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAE8BE51C;
        Wed, 19 Oct 2022 04:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D30A6CE2157;
        Wed, 19 Oct 2022 09:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50C4C433C1;
        Wed, 19 Oct 2022 09:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170220;
        bh=1OAwvSabGh6LnKItuicwtRw9I08Q/Qc3Yz5P8kejiIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNT3XQMgoTyxVBCMHZf/jf5RHQ+SvhM/NLbITtdDL/txxfriWRt0HkIQsL3h4mFOp
         EEqwgmIxHHydCYJnLYnFT4Bbvh8wQcigyVvIXdgsG7Ph0/mtXcF2++fVinaSEnkmGt
         ussTs7x1W8ncngz2BURXn6bAN1X8GQVRvfOI3nZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 573/862] fsi: core: Check error number after calling ida_simple_get
Date:   Wed, 19 Oct 2022 10:31:00 +0200
Message-Id: <20221019083315.296999903@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3a7b78e36701..5858e6339a10 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -1314,6 +1314,9 @@ int fsi_master_register(struct fsi_master *master)
 
 	mutex_init(&master->scan_lock);
 	master->idx = ida_simple_get(&master_ida, 0, INT_MAX, GFP_KERNEL);
+	if (master->idx < 0)
+		return master->idx;
+
 	dev_set_name(&master->dev, "fsi%d", master->idx);
 	master->dev.class = &fsi_master_class;
 
-- 
2.35.1



