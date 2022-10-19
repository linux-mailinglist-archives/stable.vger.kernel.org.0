Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317966047EF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiJSNr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiJSNqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:46:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67516172527;
        Wed, 19 Oct 2022 06:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D6F1B82461;
        Wed, 19 Oct 2022 09:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF861C433C1;
        Wed, 19 Oct 2022 09:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170065;
        bh=vpqfbiunWovxa5YCg5882NV1JJiUtyPwMIje/6zZPJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3ziCNs7eFbbSyGyu0W9JNISyxAor8yDDfq7eHJfLTBIz9fNuwLDuCGRlqcTf5aa6
         iuikciD41aljedEDcZeftuVKzrLO6g+lqx0M9qOaerZ7hqGj3kdZlybv5GHyA0b07Z
         9VnpDsHgxHcNL1M3Qmt2TIBV+ToOSuk1xZEuogio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 512/862] usb: gadget: f_fs: stricter integer overflow checks
Date:   Wed, 19 Oct 2022 10:29:59 +0200
Message-Id: <20221019083312.610349805@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f57004b9d96755cd6a243b51c267be4016b4563c ]

This from static analysis.  The vla_item() takes a size and adds it to
the total.  It has a built in integer overflow check so if it encounters
an integer overflow anywhere then it records the total as SIZE_MAX.

However there is an issue here because the "lang_count*(needed_count+1)"
multiplication can overflow.  Technically the "lang_count + 1" addition
could overflow too, but that would be detected and is harmless.  Fix
both using the new size_add() and size_mul() functions.

Fixes: e6f3862fa1ec ("usb: gadget: FunctionFS: Remove VLAIS usage from gadget code")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YxDI3lMYomE7WCjn@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index e0fa4b186ec6..36184a762527 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2645,10 +2645,10 @@ static int __ffs_data_got_strings(struct ffs_data *ffs,
 		unsigned i = 0;
 		vla_group(d);
 		vla_item(d, struct usb_gadget_strings *, stringtabs,
-			lang_count + 1);
+			size_add(lang_count, 1));
 		vla_item(d, struct usb_gadget_strings, stringtab, lang_count);
 		vla_item(d, struct usb_string, strings,
-			lang_count*(needed_count+1));
+			size_mul(lang_count, (needed_count + 1)));
 
 		char *vlabuf = kmalloc(vla_group_size(d), GFP_KERNEL);
 
-- 
2.35.1



