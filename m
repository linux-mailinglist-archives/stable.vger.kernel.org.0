Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3F76B4B35
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjCJPfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjCJPes (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:34:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1F314783B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68FDA61745
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF37C4339E;
        Fri, 10 Mar 2023 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461430;
        bh=5f1BYfMrrvm2K95uuqXp0UE0kR9Po0RPJl77QJ/a1a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a11NEXEO0w9Wu5DObZHq65i6wPc/HZQ3pPoWQeouJrSi7xoQXTTo3y3ROQi4uZwRx
         5ogoseWCgMHngmsLplyLvRDetAzaw812w5e/b9HA3guzqWZkD3jzBdWKwo/mH51m6P
         iOm/TfVyuOK05R8hB/NJleRyV1BORjmrYdKFBbqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.15 136/136] usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails
Date:   Fri, 10 Mar 2023 14:44:18 +0100
Message-Id: <20230310133711.349752118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 7ebb605d2283fb2647b4fa82030307ce00bee436 upstream.

If kstrtou8() fails, the mutex_unlock() is missed, move kstrtou8()
before mutex_lock() to fix it up.

Fixes: 0525210c9840 ("usb: gadget: uvc: Allow definition of XUs in configfs")
Fixes: b3c839bd8a07 ("usb: gadget: uvc: Make bSourceID read/write")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230213070926.776447-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_configfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -546,6 +546,10 @@ static ssize_t uvcg_default_output_b_sou
 	int result;
 	u8 num;
 
+	result = kstrtou8(page, 0, &num);
+	if (result)
+		return result;
+
 	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
 
 	opts_item = group->cg_item.ci_parent->ci_parent->
@@ -553,10 +557,6 @@ static ssize_t uvcg_default_output_b_sou
 	opts = to_f_uvc_opts(opts_item);
 	cd = &opts->uvc_output_terminal;
 
-	result = kstrtou8(page, 0, &num);
-	if (result)
-		return result;
-
 	mutex_lock(&opts->lock);
 	cd->bSourceID = num;
 	mutex_unlock(&opts->lock);


