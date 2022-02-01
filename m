Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3BD4A6380
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiBASRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242109AbiBASRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35BFC061714;
        Tue,  1 Feb 2022 10:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0FD9DCE1A60;
        Tue,  1 Feb 2022 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EFAC340EC;
        Tue,  1 Feb 2022 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739463;
        bh=0EKPcPSJAjJUftzyKgDL00gEEUA48G3uTM5STcqHt6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vvhwpp9jA2+4ViOCdT+/H7vA/KbB7fh786LXgoYwjgw3DYec+XNfKsmzYhXGmc/SW
         +i1OpipQYqlRw3BsuteTzBlBXvOFAyOGMQ+AQq+stu6iT5JGgazGjJDhFEXeyL+ICA
         gaohI0FSd36o+UTPRIRbJkJeNuj8pgUbApdEB1DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Guillaume Bertholon" 
        <guillaume.bertholon@ens.fr>,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.4 23/25] Revert "drm/radeon/ci: disable mclk switching for high refresh rates (v2)"
Date:   Tue,  1 Feb 2022 19:16:47 +0100
Message-Id: <20220201180822.902763547@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

This reverts commit 0157e2a8a71978c58a7d6cfb3616ab17d9726631.

The reverted commit was backported and applied twice on the stable branch:
- First as commit 15de2e4c90b7 ("drm/radeon/ci: disable mclk switching for
high refresh rates (v2)")
- Then as commit 0157e2a8a719 ("drm/radeon/ci: disable mclk switching for
high refresh rates (v2)")

Fixes: 0157e2a8a719 ("drm/radeon/ci: disable mclk switching for high refresh rates (v2)")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -782,12 +782,6 @@ bool ci_dpm_vblank_too_short(struct rade
 	if (r600_dpm_get_vrefresh(rdev) > 120)
 		return true;
 
-	/* disable mclk switching if the refresh is >120Hz, even if the
-        * blanking period would allow it
-        */
-	if (r600_dpm_get_vrefresh(rdev) > 120)
-		return true;
-
 	if (vblank_time < switch_limit)
 		return true;
 	else


