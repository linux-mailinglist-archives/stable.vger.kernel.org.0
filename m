Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E1C676F9E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjAVPXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjAVPXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5D32D6F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 661D260C64
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7385FC4339C;
        Sun, 22 Jan 2023 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400999;
        bh=uiX3x6NTwijFDt7jKKVMjNAfNDsZMop0oaVFnPU+Eiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKjZFAKp+cWKLo2P7HhDwLP+CQfWlb6VNXg1We5Fdoz61lxxoKV9id3TfIYfhSEO3
         XgbHrKFnfC/eVY33voTYnaCGtYg+l1PvyskaDEur0cRvHEdlAzqgLU+nqjQ58f+f8p
         IoBZCwuBmqcVfP/epVpEE3ON+LEWJTTna9wDZQHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 064/193] staging: vchiq_arm: fix enum vchiq_status return types
Date:   Sun, 22 Jan 2023 16:03:13 +0100
Message-Id: <20230122150249.278639331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 7d83299351fe7c812c529f5e39fe63b5312e4233 upstream.

gcc-13 notices a type mismatch between function declaration
and definition for a few functions that have been converted
from returning vchiq specific status values to regular error
codes:

drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:662:5: error: conflicting types for 'vchiq_initialise' due to enum/integer mismatch; have 'int(struct vchiq_instance **)' [-Werror=enum-int-mismatch]
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:1411:1: error: conflicting types for 'vchiq_use_internal' due to enum/integer mismatch; have 'int(struct vchiq_state *, struct vchiq_service *, enum USE_TYPE_E)' [-Werror=enum-int-mismatch]
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c:1468:1: error: conflicting types for 'vchiq_release_internal' due to enum/integer mismatch; have 'int(struct vchiq_state *, struct vchiq_service *)' [-Werror=enum-int-mismatch]

Change the declarations to match the actual function definition.

Fixes: a9fbd828be7f ("staging: vchiq_arm: drop enum vchiq_status from vchiq_*_internal")
Cc: stable <stable@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230117163957.1109872-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h |    2 +-
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
+++ b/drivers/staging/vc04_services/include/linux/raspberrypi/vchiq.h
@@ -86,7 +86,7 @@ struct vchiq_service_params_kernel {
 
 struct vchiq_instance;
 
-extern enum vchiq_status vchiq_initialise(struct vchiq_instance **pinstance);
+extern int vchiq_initialise(struct vchiq_instance **pinstance);
 extern enum vchiq_status vchiq_shutdown(struct vchiq_instance *instance);
 extern enum vchiq_status vchiq_connect(struct vchiq_instance *instance);
 extern enum vchiq_status vchiq_open_service(struct vchiq_instance *instance,
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.h
@@ -100,10 +100,10 @@ vchiq_dump_platform_use_state(struct vch
 extern void
 vchiq_dump_service_use_state(struct vchiq_state *state);
 
-extern enum vchiq_status
+extern int
 vchiq_use_internal(struct vchiq_state *state, struct vchiq_service *service,
 		   enum USE_TYPE_E use_type);
-extern enum vchiq_status
+extern int
 vchiq_release_internal(struct vchiq_state *state,
 		       struct vchiq_service *service);
 


