Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E082B68D86F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjBGNJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjBGNJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54583B0D8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC580B81977
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0CEC433EF;
        Tue,  7 Feb 2023 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775328;
        bh=4smbWeCBAUMO3z05FeL6wI8xmb0nj2NbxhZE+VwPpBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix3yF0vJ3Oc2Thw2xjtWvDgH5WOK+q0Dl5V9SIyJhx7ijzGEtBZfuxJSFNWjoPdZw
         zlgNQyJ2QZc+49vmKRVSxCvnn44xiYyUz2z8+sggctOsMqDpI6Vv21GN6yNSdU4Vjp
         UdStGg7gIrlDEIEg3rJSB3t21ZKl21XR7gb5qR94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 184/208] nvmem: core: initialise nvmem->id early
Date:   Tue,  7 Feb 2023 13:57:18 +0100
Message-Id: <20230207125642.811200965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 3bd747c7ea13cb145f0d84444e00df928b0842d9 upstream.

The error path for wp_gpio attempts to free the IDA nvmem->id, but
this has yet to be assigned, so will always be zero - leaking the
ID allocated by ida_alloc(). Fix this by moving the initialisation
of nvmem->id earlier.

Fixes: f7d8d7dcd978 ("nvmem: fix memory leak in error path")
Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -770,6 +770,8 @@ struct nvmem_device *nvmem_register(cons
 		return ERR_PTR(rval);
 	}
 
+	nvmem->id = rval;
+
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
 	else if (!config->ignore_wp)
@@ -785,7 +787,6 @@ struct nvmem_device *nvmem_register(cons
 	kref_init(&nvmem->refcnt);
 	INIT_LIST_HEAD(&nvmem->cells);
 
-	nvmem->id = rval;
 	nvmem->owner = config->owner;
 	if (!nvmem->owner && config->dev->driver)
 		nvmem->owner = config->dev->driver->owner;


