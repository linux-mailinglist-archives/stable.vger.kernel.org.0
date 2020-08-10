Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE96240A5D
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHJPX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgHJPX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:23:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6432320772;
        Mon, 10 Aug 2020 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073008;
        bh=jmFDcZ8vPo5JsDA6rhoJdQuuBC/wXnUd4I/ZMyNDUAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnFD8QyF/JUvgYvz4b14zFjc09KJQbAvAtGt6Ki7slrf5Io8dWmyQNXCV6vm7lNlm
         S6j/y+w37SHRQsNAeaY/4gd9ToY5h3lh33EwPbmdxZ4sgfzfSWJP7djMTdI11eEfZ8
         6/BjliDDRy6x76pvLoCkY/aNdYpJOIRlX2DLvvhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 33/79] drm/nouveau/kms/tu102: wait for core update to complete when assigning windows
Date:   Mon, 10 Aug 2020 17:20:52 +0200
Message-Id: <20200810151813.925318979@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 705d9d022949e3cdae82d89db6a8fc773eb23dad ]

Fixes a race on Turing between the core cross-channel error checks and
the following window update.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 2625ed84fc44d..5835d19e1c45f 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2041,7 +2041,7 @@ nv50_disp_atomic_commit_tail(struct drm_atomic_state *state)
 	 */
 	if (core->assign_windows) {
 		core->func->wndw.owner(core);
-		core->func->update(core, interlock, false);
+		nv50_disp_atomic_commit_core(state, interlock);
 		core->assign_windows = false;
 		interlock[NV50_DISP_INTERLOCK_CORE] = 0;
 	}
-- 
2.25.1



