Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8219766CAC5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbjAPRH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbjAPRGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:06:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866953A5B9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:47:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE3361037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FFBC433EF;
        Mon, 16 Jan 2023 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887673;
        bh=Bzwnc8OCkWjBLY+z6WS25xi9oj63tmSbP5tzDi7MBYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0ZCRfm6KBF7lNHFWEq4uuNMPo24V/H7fQOL9cHdEIywio0PsoKdBkHz0xf3ELbHC
         mzg/qrJWi+xLPDvQx9o4Tfnc/AQKyMwtcWC6ZyBFYj3uJqW+SyIbJW8KjO+BuYKfas
         HgwCP4FHjti6en/AJxkCm/0X+4o20JElVD3v51Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Keeping <john@metanate.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/521] usb: gadget: f_hid: fix refcount leak on error path
Date:   Mon, 16 Jan 2023 16:48:21 +0100
Message-Id: <20230116154857.824506089@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: John Keeping <john@metanate.com>

[ Upstream commit 70a3288a7586526315105c699b687d78cd32559a ]

When failing to allocate report_desc, opts->refcnt has already been
incremented so it needs to be decremented to avoid leaving the options
structure permanently locked.

Fixes: 21a9476a7ba8 ("usb: gadget: hid: add configfs support")
Tested-by: Lee Jones <lee@kernel.org>
Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20221122123523.3068034-3-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 2aaa3ea74e5a..ea877cba0763 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1298,6 +1298,7 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
 						 GFP_KERNEL);
 		if (!hidg->report_desc) {
 			put_device(&hidg->dev);
+			--opts->refcnt;
 			mutex_unlock(&opts->lock);
 			return ERR_PTR(-ENOMEM);
 		}
-- 
2.35.1



