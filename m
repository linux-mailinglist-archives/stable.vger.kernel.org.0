Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F7B8DA5C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbfHNRRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbfHNRN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D1520665;
        Wed, 14 Aug 2019 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802807;
        bh=2BRhctLSAlDBYIzq8eGchra/IL7na6tu5i82yuhPupw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyZxWfa5LTK6CYbQuc40928hLlLQIS1e0aynjixLGbtQwt9XkO9/LnDYBc+UonsXO
         nf22YYacT5yHSPzajOP8bJuRiPdBbxF8SnOuAPqTdfTjT9P8pU2t5b1ltuttd7uxkU
         eXORYSFA163i4V9zi1oVwcJQsEH+AR5v8jYqx6FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/69] drm: silence variable conn set but not used
Date:   Wed, 14 Aug 2019 19:01:31 +0200
Message-Id: <20190814165747.785563727@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bbb6fc43f131f77fcb7ae8081f6d7c51396a2120 ]

The "struct drm_connector" iteration cursor from
"for_each_new_connector_in_state" is never used in atomic_remove_fb()
which generates a compilation warning,

drivers/gpu/drm/drm_framebuffer.c: In function 'atomic_remove_fb':
drivers/gpu/drm/drm_framebuffer.c:838:24: warning: variable 'conn' set
but not used [-Wunused-but-set-variable]

Silence it by marking "conn" __maybe_unused.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1563822886-13570-1-git-send-email-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_framebuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index c21e10c780ac5..af40189cdb60c 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -773,7 +773,7 @@ static int atomic_remove_fb(struct drm_framebuffer *fb)
 	struct drm_device *dev = fb->dev;
 	struct drm_atomic_state *state;
 	struct drm_plane *plane;
-	struct drm_connector *conn;
+	struct drm_connector *conn __maybe_unused;
 	struct drm_connector_state *conn_state;
 	int i, ret = 0;
 	unsigned plane_mask;
-- 
2.20.1



