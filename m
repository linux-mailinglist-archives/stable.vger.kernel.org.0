Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF860BA11
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiJXUZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJXUXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F04BDFA9;
        Mon, 24 Oct 2022 11:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4BE3B815F2;
        Mon, 24 Oct 2022 12:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C98DC433D6;
        Mon, 24 Oct 2022 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613560;
        bh=KqJLZ6cRDvhGDBZ0Cn5kRIj2K7+4uDN50DC5R9l8bLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F739Hle2KcghIukFwsHB048C9d7xiQDi9sBMal7CgdYgERu8uzHS9HXGjJ7n79gYE
         tjXa2XjekJXG60RJVWEmlZjLfNfJRxoI40SilGEiHbwQrgTc0uG8m9nic8yBdASmBL
         9uEiGWUfcIAV8LJTS8Lcl67LhY4MzWp809nVe/1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/255] fsi: core: Check error number after calling ida_simple_get
Date:   Mon, 24 Oct 2022 13:31:06 +0200
Message-Id: <20221024113007.831407481@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index cb980a60af0e..09e571578232 100644
--- a/drivers/fsi/fsi-core.c
+++ b/drivers/fsi/fsi-core.c
@@ -1271,6 +1271,9 @@ int fsi_master_register(struct fsi_master *master)
 
 	mutex_init(&master->scan_lock);
 	master->idx = ida_simple_get(&master_ida, 0, INT_MAX, GFP_KERNEL);
+	if (master->idx < 0)
+		return master->idx;
+
 	dev_set_name(&master->dev, "fsi%d", master->idx);
 
 	rc = device_register(&master->dev);
-- 
2.35.1



