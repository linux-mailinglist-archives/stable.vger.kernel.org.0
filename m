Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B6247AF70
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbhLTPMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238822AbhLTPKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:10:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33AC0A88E6;
        Mon, 20 Dec 2021 06:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 422F7611CB;
        Mon, 20 Dec 2021 14:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28521C36AE7;
        Mon, 20 Dec 2021 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012167;
        bh=fiutcu2IIW4WF9Wf4EE/yAlxFumoik1XrYrlc2pZlAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRRlLuF5v/EOmvqe/NCJrsBOjLyk+s5o92e7LRKOluaBodBnEUcckmUYBkX5/hnC6
         jvHW9FGCIp/ApR3hSDqUz2YMSVjjog19IUMXGTUU7yUlITe+8N0zu38iGjxL4euPxY
         repbztR63QBjCZpJYdchhCJ42PQGE5dEuIt2EWn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/177] drm: simpledrm: fix wrong unit with pixel clock
Date:   Mon, 20 Dec 2021 15:33:42 +0100
Message-Id: <20211220143042.528442120@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>

[ Upstream commit 5cf06065bd1f7b94fbb80e7eeb033899f77ab5ba ]

Pixel clock has to be set in kHz.

Signed-off-by: Alejandro Concepcion-Rodriguez <asconcepcion@acoro.eu>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/6f8554ef-1305-0dda-821c-f7d2e5644a48@acoro.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 481b48bde0473..5a6e89825bc2f 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -458,7 +458,7 @@ static struct drm_display_mode simpledrm_mode(unsigned int width,
 {
 	struct drm_display_mode mode = { SIMPLEDRM_MODE(width, height) };
 
-	mode.clock = 60 /* Hz */ * mode.hdisplay * mode.vdisplay;
+	mode.clock = mode.hdisplay * mode.vdisplay * 60 / 1000 /* kHz */;
 	drm_mode_set_name(&mode);
 
 	return mode;
-- 
2.33.0



