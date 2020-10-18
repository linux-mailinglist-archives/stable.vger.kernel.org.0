Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C8D291A3C
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgJRTWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbgJRTWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF94222C8;
        Sun, 18 Oct 2020 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048960;
        bh=smJtv4KfydbSkmsiDSlGG1z0Vf1IgmeJiVxaptl62kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZ0cvoYpv91bdUL1UqURXpx6UFOkiuldVAkinJI9OJKTQTuBo8Ip7/rN/uMxOJn86
         Ek3+D7+jv2ve/e006FUGpEXi2ptEZGakcNLOGooFOUxE8Y/0VAKnvmmYg4bHL36TeZ
         GKHmRLHJWuzKMsQgA9WemrZlw0xUOvN2nZYpX6fo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@denx.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 06/80] media: firewire: fix memory leak
Date:   Sun, 18 Oct 2020 15:21:17 -0400
Message-Id: <20201018192231.4054535-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

[ Upstream commit b28e32798c78a346788d412f1958f36bb760ec03 ]

Fix memory leak in node_probe.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/firewire/firedtv-fw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
index 3f1ca40b9b987..8a8585261bb80 100644
--- a/drivers/media/firewire/firedtv-fw.c
+++ b/drivers/media/firewire/firedtv-fw.c
@@ -272,8 +272,10 @@ static int node_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 
 	name_len = fw_csr_string(unit->directory, CSR_MODEL,
 				 name, sizeof(name));
-	if (name_len < 0)
-		return name_len;
+	if (name_len < 0) {
+		err = name_len;
+		goto fail_free;
+	}
 	for (i = ARRAY_SIZE(model_names); --i; )
 		if (strlen(model_names[i]) <= name_len &&
 		    strncmp(name, model_names[i], name_len) == 0)
-- 
2.25.1

