Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65F7667653
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbjALOam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbjALOaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB0458F96
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 356F260C01
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46158C433D2;
        Thu, 12 Jan 2023 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533289;
        bh=50ow/X8mAdybbxLFGEt5Qy11Y+GlBtkQEH/rytZpPvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzIkbfNlKjjWcvx23/ngAb+/vLBxRzcta5W5JJw9WaWrm9KzDlQ84BzTYoYua3uDx
         U1Pr9VLL9ZnevG6RneCn5Cl9PIOOIUoNl/DTdd1ntGjdBa14dC1kR4pJM8hDQpvSIh
         XZK0EkE2WXzOlTGFwRXVbcyOhwC/hL8LipojPaus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/783] macintosh: fix possible memory leak in macio_add_one_device()
Date:   Thu, 12 Jan 2023 14:52:26 +0100
Message-Id: <20230112135544.248875397@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 5ca86eae55a2f006e6c1edd2029b2cacb6979515 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically. It
needs to be freed when of_device_register() fails. Call put_device() to
give up the reference that's taken in device_initialize(), so that it
can be freed in kobject_cleanup() when the refcount hits 0.

macio device is freed in macio_release_dev(), so the kfree() can be
removed.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221104032551.1075335-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/macio_asic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 49af60bdac92..7db2e23a5ac8 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -425,7 +425,7 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 	if (of_device_register(&dev->ofdev) != 0) {
 		printk(KERN_DEBUG"macio: device registration error for %s!\n",
 		       dev_name(&dev->ofdev.dev));
-		kfree(dev);
+		put_device(&dev->ofdev.dev);
 		return NULL;
 	}
 
-- 
2.35.1



