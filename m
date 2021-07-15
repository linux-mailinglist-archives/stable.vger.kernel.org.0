Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E561C3CAAEC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhGOTQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244676AbhGOTPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823E761419;
        Thu, 15 Jul 2021 19:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376267;
        bh=Jj+qxO9uQu4VlJFCOItiFlKT7Z1OzVTswRFWi2+JbfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9c6voVCFEJAsehhIasSa5BAgObBza+9GEK4cEpac/S1db84OAgPVUDfFvr4Wl39G
         rx0Z4RGrOBTNEiNHgpFxSAyTyNwI50AYTRtYN0XojltT55nO8XDGIuOOG/xMNTWO7Z
         mfexnSZ0sc73gKeMtBuhCfNRP5o8FghqTHzks6f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>
Subject: [PATCH 5.13 197/266] drm/amd/display: fix incorrrect valid irq check
Date:   Thu, 15 Jul 2021 20:39:12 +0200
Message-Id: <20210715182645.285452979@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

commit e38ca7e422791a4d1c01e56dbf7f9982db0ed365 upstream.

valid DAL irq should be < DAL_IRQ_SOURCES_NUMBER.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-and-tested-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/irq_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/irq_types.h
+++ b/drivers/gpu/drm/amd/display/dc/irq_types.h
@@ -165,7 +165,7 @@ enum irq_type
 };
 
 #define DAL_VALID_IRQ_SRC_NUM(src) \
-	((src) <= DAL_IRQ_SOURCES_NUMBER && (src) > DC_IRQ_SOURCE_INVALID)
+	((src) < DAL_IRQ_SOURCES_NUMBER && (src) > DC_IRQ_SOURCE_INVALID)
 
 /* Number of Page Flip IRQ Sources. */
 #define DAL_PFLIP_IRQ_SRC_NUM \


