Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C7C5AB06A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbiIBMxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbiIBMwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:52:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB0DF8FD2;
        Fri,  2 Sep 2022 05:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BBE0B81CCF;
        Fri,  2 Sep 2022 12:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9041EC433D6;
        Fri,  2 Sep 2022 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122195;
        bh=sYkZkvrgtkFRSF4QEy0oqraFW7XT7ofLBS5VurAovuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJWIcffR2O6ONcFUXBtfeyybCG2c5waWRcc/L0paNUB/HvvdOufgBNpxEVqqg/cQX
         GZpqTPWLKznLVdhNHy2Zyj9bhtaDNgmqjdgyQAt4+VhNObeo14Lo9p12KKCYhG/N0m
         Zwc3Ghl3bgh9CYE8nmSiPDpP8gNMUuYAiXJdmrJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Kizito <Jimmy.Kizito@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Tom Chung <chiahsuan.chung@amd.com>,
        Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 42/72] drm/amd/display: Fix TDR eDP and USB4 display light up issue
Date:   Fri,  2 Sep 2022 14:19:18 +0200
Message-Id: <20220902121406.146940764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit 30456ffa65469d1d2e5e1da05017e6728d24c11c ]

[Why]
After TDR recovery, eDP and USB4 display does not light up. Because
dmub outbox notifications are not enabled after dmub reload and link
encoder assignments for the streams are not cleared before dc state
reset.

[How]
- Dmub outbox notification is enabled after tdr recovery by issuing
  inbox command to dmub.
- Link encoders for the streams are unassigned before dc state reset.

Reviewed-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 drivers/gpu/drm/amd/display/dc/dc_link.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index f144494011882..7d69341acca02 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3783,6 +3783,7 @@ void dc_enable_dmub_outbox(struct dc *dc)
 	struct dc_context *dc_ctx = dc->ctx;
 
 	dmub_enable_outbox_notification(dc_ctx->dmub_srv);
+	DC_LOG_DC("%s: dmub outbox notifications enabled\n", __func__);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index a3c37ee3f849c..f96f53c1bc258 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -337,6 +337,7 @@ enum dc_detect_reason {
 	DETECT_REASON_HPDRX,
 	DETECT_REASON_FALLBACK,
 	DETECT_REASON_RETRAIN,
+	DETECT_REASON_TDR,
 };
 
 bool dc_link_detect(struct dc_link *dc_link, enum dc_detect_reason reason);
-- 
2.35.1



