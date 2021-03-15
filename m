Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA0333B86C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCOOD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhCOOAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5AC364F10;
        Mon, 15 Mar 2021 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816770;
        bh=hpWliGdWTSzUspnrrpLNFn+UavCc+KbbZDyvcKJn5OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSJDWDTtqsGKjRYZLLHssUrJFAcuCFlZ6TSPI+kQnDp3oajOdBZfHZawqVLlyefq2
         EBTxeRhv5KphyYjVcGxTeJWEgV9MG0UJ6cp+l3zysF0PwBT8h5JOf01mewZX946i80
         d7cYczdp5H9j6lxGgi+3YxlIEoQ1vuRuaJdBL6Uk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 5.11 114/306] qxl: Fix uninitialised struct field head.surface_id
Date:   Mon, 15 Mar 2021 14:52:57 +0100
Message-Id: <20210315135511.495921925@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Colin Ian King <colin.king@canonical.com>

commit 738acd49eb018feb873e0fac8f9517493f6ce2c7 upstream.

The surface_id struct field in head is not being initialized and
static analysis warns that this is being passed through to
dev->monitors_config->heads[i] on an assignment. Clear up this
warning by initializing it to zero.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: a6d3c4d79822 ("qxl: hook monitors_config updates into crtc, not encoder.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210304094928.2280722-1-colin.king@canonical.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/qxl/qxl_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -328,6 +328,7 @@ static void qxl_crtc_update_monitors_con
 
 	head.id = i;
 	head.flags = 0;
+	head.surface_id = 0;
 	oldcount = qdev->monitors_config->count;
 	if (crtc->state->active) {
 		struct drm_display_mode *mode = &crtc->mode;


