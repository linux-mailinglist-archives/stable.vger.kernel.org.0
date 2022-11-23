Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21E763536C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbiKWIzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbiKWIz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:55:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C973F2C37
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED88561B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03EEC433D7;
        Wed, 23 Nov 2022 08:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193725;
        bh=3ck9Xe5tg1QfdZeBDOx83UjQJzLEsPFRPeEwmuhrhc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHc1GO5qPER898hQ7GgqeGM4xaH5Txm72UhJFHLIvEP9t7cbsMYpulPQu6Bdj3QpB
         4jFwmsIedjAs/ZWQv9wX06kp61571Xca2hCA63hLg+6xO2GHojD6hIoimSq1kMhmx7
         do+dnjg5aNdYdbHT+CihmwLqKvhQnSW1N5qhiyDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 43/76] xen/pcpu: fix possible memory leak in register_pcpu()
Date:   Wed, 23 Nov 2022 09:50:42 +0100
Message-Id: <20221123084548.155239735@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit da36a2a76b01b210ffaa55cdc2c99bc8783697c5 ]

In device_add(), dev_set_name() is called to allocate name, if it returns
error, the name need be freed. As comment of device_register() says, it
should use put_device() to give up the reference in the error path. So fix
this by calling put_device(), then the name can be freed in kobject_cleanup().

Fixes: f65c9bb3fb72 ("xen/pcpu: Xen physical cpus online/offline sys interface")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221110152441.401630-1-yangyingliang@huawei.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index cdc6daa7a9f6..9cf7085a260b 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -228,7 +228,7 @@ static int register_pcpu(struct pcpu *pcpu)
 
 	err = device_register(dev);
 	if (err) {
-		pcpu_release(dev);
+		put_device(dev);
 		return err;
 	}
 
-- 
2.35.1



