Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5224261729
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731733AbgIHR07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731730AbgIHQQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:16:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D735024824;
        Tue,  8 Sep 2020 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579855;
        bh=g+Y6OJgjtiO5LtwGG8TxanGgSG6X9uTXvfM7dtbP7T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXM6YtazehkDsYIp9Sp/nLSZBtHxgV7rvovVcJCGiUME7BotACMbA5KPfZ4W8io7N
         RDDgVYz3ydgAyF85YD+U2Er/XPKpGwZ9BJ6Y9cKbDH/W2BOy98l+LgEgR+ZqXWZEG5
         zbCso3bcOuLu5iIEd/tPGuXzs/xUYXKaothnu2WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/129] drm/radeon: Prefer lower feedback dividers
Date:   Tue,  8 Sep 2020 17:25:02 +0200
Message-Id: <20200908152232.749853677@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit fc8c70526bd30733ea8667adb8b8ffebea30a8ed ]

Commit 2e26ccb119bd ("drm/radeon: prefer lower reference dividers")
fixed screen flicker for HP Compaq nx9420 but breaks other laptops like
Asus X50SL.

Turns out we also need to favor lower feedback dividers.

Users confirmed this change fixes the regression and doesn't regress the
original fix.

Fixes: 2e26ccb119bd ("drm/radeon: prefer lower reference dividers")
BugLink: https://bugs.launchpad.net/bugs/1791312
BugLink: https://bugs.launchpad.net/bugs/1861554
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index f9f74150d0d73..e7c4e06bc7d4f 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -932,7 +932,7 @@ static void avivo_get_fb_ref_div(unsigned nom, unsigned den, unsigned post_div,
 
 	/* get matching reference and feedback divider */
 	*ref_div = min(max(den/post_div, 1u), ref_div_max);
-	*fb_div = DIV_ROUND_CLOSEST(nom * *ref_div * post_div, den);
+	*fb_div = max(nom * *ref_div * post_div / den, 1u);
 
 	/* limit fb divider to its maximum */
 	if (*fb_div > fb_div_max) {
-- 
2.25.1



