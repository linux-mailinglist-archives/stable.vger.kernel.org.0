Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D2B5948F9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243490AbiHOXha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353726AbiHOXgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:36:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9315BCCC0;
        Mon, 15 Aug 2022 13:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D565B80EA8;
        Mon, 15 Aug 2022 20:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64750C433C1;
        Mon, 15 Aug 2022 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594154;
        bh=PG3q0yIr5lZ0sHZ80edAXdyGyli4uMYJ5uN85gDj5iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnkf8D2sdCz6j3t651dQsqY+v4omFamZ07Iswy1T6CZxjirJrdo8tvPzhbbzLlHji
         tvxlQDQVfghvfGYY+Ojq7eRJyb9SBcZT4q3XBC6D7RqXGRXDaC7uoNqVTM89STtYcE
         QszDS07zEfiuXSRodWnZCZmO3JsN5F6O+tA8Gj0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tim Huang <Tim.Huang@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0387/1157] drm/amdkfd: correct sdma queue number of sdma 6.0.1
Date:   Mon, 15 Aug 2022 19:55:43 +0200
Message-Id: <20220815180455.178511421@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit efb4fd107cfd9748f777a4e9015d803d3c9db68b ]

sdma 6.0.1 has 8 queues instead of 2.

Fixes: 26776a7031c423 ("drm/amdkfd: add GC 11.0.1 KFD support")
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index a08769c5e94b..d9f57a20a8bc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -75,7 +75,6 @@ static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
 	case IP_VERSION(5, 2, 3):/* YELLOW_CARP */
 	case IP_VERSION(5, 2, 6):/* GC 10.3.6 */
 	case IP_VERSION(5, 2, 7):/* GC 10.3.7 */
-	case IP_VERSION(6, 0, 1):
 		kfd->device_info.num_sdma_queues_per_engine = 2;
 		break;
 	case IP_VERSION(4, 2, 0):/* VEGA20 */
@@ -90,6 +89,7 @@ static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
 	case IP_VERSION(5, 2, 4):/* DIMGREY_CAVEFISH */
 	case IP_VERSION(5, 2, 5):/* BEIGE_GOBY */
 	case IP_VERSION(6, 0, 0):
+	case IP_VERSION(6, 0, 1):
 	case IP_VERSION(6, 0, 2):
 		kfd->device_info.num_sdma_queues_per_engine = 8;
 		break;
-- 
2.35.1



