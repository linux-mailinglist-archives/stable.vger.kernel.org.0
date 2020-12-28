Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533132E683F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441986AbgL1QeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgL1NC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8142521D94;
        Mon, 28 Dec 2020 13:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160532;
        bh=ZijW0fd6+XeeCoA6v6xCG6PygtIcTmm7hOp34t7rj+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeEoW3OtllEcF+ZUXhLURT86ToqeVjhOJEcRgo9oQlKDKS3SHvarqazBfhYn/N6m1
         omS1rtGhNPDesKDnw39bZZi5TC0H1oxUjMy5EBUUK9JByTEpXm3Q6k4I6YQAxMJ3w2
         nOeEcSlnE0pVii7sWosoqhDkPT5j2yMVLwawNuX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 082/175] media: siano: fix memory leak of debugfs members in smsdvb_hotplug
Date:   Mon, 28 Dec 2020 13:48:55 +0100
Message-Id: <20201228124857.212997058@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit abf287eeff4c6da6aa804bbd429dfd9d0dfb6ea7 ]

When dvb_create_media_graph fails, the debugfs kept inside client should
be released. However, the current implementation does not release them.

Fix this by adding a new goto label to call smsdvb_debugfs_release.

Fixes: 0d3ab8410dcb ("[media] dvb core: must check dvb_create_media_graph()")
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/siano/smsdvb-main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 9148e14c9d077..9d5eb8b6aede9 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1180,12 +1180,15 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	rc = dvb_create_media_graph(&client->adapter, true);
 	if (rc < 0) {
 		pr_err("dvb_create_media_graph failed %d\n", rc);
-		goto client_error;
+		goto media_graph_error;
 	}
 
 	pr_info("DVB interface registered.\n");
 	return 0;
 
+media_graph_error:
+	smsdvb_debugfs_release(client);
+
 client_error:
 	dvb_unregister_frontend(&client->frontend);
 
-- 
2.27.0



