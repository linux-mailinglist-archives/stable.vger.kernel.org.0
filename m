Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045A568104B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbjA3OCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbjA3OB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC73B0F8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 082D2CE16A2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C3FC433D2;
        Mon, 30 Jan 2023 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087303;
        bh=xAh+mZBTjyXc02GfpBdy2kVtCLScRHuFrJZt3/rJ90Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foIq4zxFirsMyXBsYOp1GFRoIAOz8zmbcxY1HM9LQxXzL+aQpIeNJflONQek7z6ly
         vb6mWfoefm5wBvRrNaLVvqodU+bD9XE8ZqJI1qUozCsvCfeX/AU9nPjKRGjnhw7o+t
         ONkjE5qO/qFetHojjMg/1X9ZH8y1ln8lSchU3zFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/313] thermal/core: fix error code in __thermal_cooling_device_register()
Date:   Mon, 30 Jan 2023 14:49:31 +0100
Message-Id: <20230130134342.988416571@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index 328da2f1d339..449e60c4a1b6 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -892,7 +892,8 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
 
-	if (cdev->ops->get_max_state(cdev, &cdev->max_state))
+	ret = cdev->ops->get_max_state(cdev, &cdev->max_state);
+	if (ret)
 		goto out_kfree_type;
 
 	thermal_cooling_device_setup_sysfs(cdev);
-- 
2.39.0



