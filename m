Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F142D681180
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbjA3OOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbjA3ON5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD4411C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C1FCB811C9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E84FC433D2;
        Mon, 30 Jan 2023 14:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088034;
        bh=8sPm48kRjTqRAvBdL+6nhqa/h/+Zz/g226ir9N1nbgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVJF+Yofr0b5fgCka2/jmlWTMa07la/RzaIJmQjCgxjt1oSI7H5PPGkyQXV++qVn5
         5kwhOuZP3eiFbRi+BTEhdAQlYd663NsGjU4yecQGGIsYYmiGyc7gs73k+xuwxxzJWH
         rxhPAd7yFT8XdA9UL2bQ0Yh1qCNNQ5knFzbQGC3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/204] thermal/core: fix error code in __thermal_cooling_device_register()
Date:   Mon, 30 Jan 2023 14:50:57 +0100
Message-Id: <20230130134320.390887218@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e49a1e1ee078aee21006192076a8d93335e0daa9 ]

Return an error pointer if ->get_max_state() fails.  The current code
returns NULL which will cause an oops in the callers.

Fixes: c408b3d1d9bb ("thermal: Validate new state in cur_state_store()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 6c54b7bc8a31 ("thermal: core: call put_device() only after device_register() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 96d6082864ee..b21d886aef22 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -914,7 +914,8 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
 
-	if (cdev->ops->get_max_state(cdev, &cdev->max_state))
+	ret = cdev->ops->get_max_state(cdev, &cdev->max_state);
+	if (ret)
 		goto out_kfree_type;
 
 	thermal_cooling_device_setup_sysfs(cdev);
-- 
2.39.0



