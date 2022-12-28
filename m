Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EC8657BD4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiL1P0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiL1PZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:25:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD69140EE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:25:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C1F6156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AC2C433EF;
        Wed, 28 Dec 2022 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241138;
        bh=H+3m3H5k6fUt8KOt+9nh9x+589HXgKljkSvmX6rEwDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AloId63E2SHkZ6Ml8OOyPqlpV3E6XiS+1V33pnWXuMGQP3SzjlXsXyMJeEWk7aU8P
         lp5FDz0KL3M6JiVfVf1mnOap/yQWGX0of6rahYsXGf4n/M4MUHEoM1FgLcqkwZWc6A
         O1cP9zhlzj+mqVj6JnlxBc57jrjtDfml2w6l6s7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/731] vfio: platform: Do not pass return buffer to ACPI _RST method
Date:   Wed, 28 Dec 2022 15:39:09 +0100
Message-Id: <20221228144309.370123328@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 6af7ce7d619c..701bd99a8719 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -72,12 +72,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
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



