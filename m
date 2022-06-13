Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402C95489EF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381634AbiFMOIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381306AbiFMOEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADAD91590;
        Mon, 13 Jun 2022 04:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C27EB80EA7;
        Mon, 13 Jun 2022 11:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB415C34114;
        Mon, 13 Jun 2022 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120347;
        bh=IWx7xFoWogZRwrZODxV7MO2FBtVKxXoS0aet2xYMj18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dymf0PzZIy+H6HAvNeWeo8sKrWqrgsxGlnNkM4xYq+/wDfkPuXOOlbWJZzP3A/hZH
         4pdnlljO2FMGAImuu7Pp7Hfjo2j5dRsHL+90/GPyijIvupbJ8E/GCJfwIRSAw9N1TH
         Mmvn75sn09FULPJQxbJ2cf7qGnCaNp6Y/3IWiHY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesse Zhang <Jesse.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 5.18 327/339] drm/amdkfd:Fix fw version for 10.3.6
Date:   Mon, 13 Jun 2022 12:12:32 +0200
Message-Id: <20220613094936.663304861@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit a956a11ee669d069047525c8ec897b4c21a9cda1 upstream.

fix fw error when loading fw for 10.3.6

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.18.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -156,7 +156,9 @@ static void kfd_device_info_init(struct
 
 		if (gc_version < IP_VERSION(11, 0, 0)) {
 			/* Navi2x+, Navi1x+ */
-			if (gc_version >= IP_VERSION(10, 3, 0))
+			if (gc_version == IP_VERSION(10, 3, 6))
+				kfd->device_info.no_atomic_fw_version = 14;
+			else if (gc_version >= IP_VERSION(10, 3, 0))
 				kfd->device_info.no_atomic_fw_version = 92;
 			else if (gc_version >= IP_VERSION(10, 1, 1))
 				kfd->device_info.no_atomic_fw_version = 145;


