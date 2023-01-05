Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B2765EBE7
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbjAENEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbjAENDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A4D5792C
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9743F619FF
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DB6C433D2;
        Thu,  5 Jan 2023 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923824;
        bh=GoFkeYKDlatd4OVgKXOMiSahnwTNLS7UTqepXyR6BRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFQlxjipN7WUI0hligTZHxG3je33vYWiJCsCOma3oy02ZtZF8TjxINN8JiU6nNsBR
         DbwsdhNIOOYjaYNAmBT7N996WJEVc5k3IAHOroWVnGCf/HO5SYJ9iJlE9JgBcY+erg
         XWxiW9PLOn+VqI0x8HjMJf/JtJ4jFbefm++tbyU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/251] vfio: platform: Do not pass return buffer to ACPI _RST method
Date:   Thu,  5 Jan 2023 13:54:24 +0100
Message-Id: <20230105125340.651095320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit e67e070632a665c932d534b8b800477bb3111449 ]

The ACPI _RST method has no return value, there's no need to pass a return
buffer to acpi_evaluate_object().

Fixes: d30daa33ec1d ("vfio: platform: call _RST method when using ACPI")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20221018152825.891032-1-rafaelmendsr@gmail.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_platform_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 9b1b6c1e218d..d5b15630050b 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -77,12 +77,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
 				  const char **extra_dbg)
 {
 #ifdef CONFIG_ACPI
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct device *dev = vdev->device;
 	acpi_handle handle = ACPI_HANDLE(dev);
 	acpi_status acpi_ret;
 
-	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
+	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
 	if (ACPI_FAILURE(acpi_ret)) {
 		if (extra_dbg)
 			*extra_dbg = acpi_format_exception(acpi_ret);
-- 
2.35.1



