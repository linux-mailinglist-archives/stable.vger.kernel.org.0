Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74005407DC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbiFGRwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349955AbiFGRvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8693E13F432;
        Tue,  7 Jun 2022 10:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFD4D615A7;
        Tue,  7 Jun 2022 17:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B992EC34119;
        Tue,  7 Jun 2022 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623500;
        bh=n5oISyk83ja9vB3obx7iI76Zu1CIB14AI1E3u+TdMDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nS0vzueQ+bYn0P+JldB6r1ULiyExhkZ87VAygqjB6Up6r/683D/gn7qbFl6r5ujqF
         +73xEG61S/zU8ThWUuySeQ/shkcJh+4+knf/8nmAFs1YT6zMXwL4XR1kTmpwn8uQgW
         y1Ev9SyVz+eadHWSx4QKUoUWwBosVKPF/IVNrUbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 440/452] thermal/core: Fix memory leak in the error path
Date:   Tue,  7 Jun 2022 19:04:57 +0200
Message-Id: <20220607164921.674881284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

commit d44616c6cc3e35eea03ecfe9040edfa2b486a059 upstream.

Fix the following error:

 smatch warnings:
 drivers/thermal/thermal_core.c:1020 __thermal_cooling_device_register() warn: possible memory leak of 'cdev'

by freeing the cdev when exiting the function in the error path.

Fixes: 584837618100 ("thermal/drivers/core: Use a char pointer for the cooling device name")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210319202257.890848-1-daniel.lezcano@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1152,6 +1152,7 @@ out_kfree_type:
 out_ida_remove:
 	ida_simple_remove(&thermal_cdev_ida, id);
 out_kfree_cdev:
+	kfree(cdev);
 	return ERR_PTR(ret);
 }
 


