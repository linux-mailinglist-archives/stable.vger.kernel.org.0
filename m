Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4581212AC
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLPRzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbfLPRzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02A3021582;
        Mon, 16 Dec 2019 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518908;
        bh=tkBwZWKRU0kFMlF9EgsngJ/FYxr470C3jk/RjB6mUqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3LfwbWmiABjSeKdiApCssTEZHkHgFRMIHmMsqm2QxLx8r6mP8BdbeJ5q0bOmxOBs
         r2+wNwp4YCOvOUFeIVsfUv19oZrXE3Ngrj//T8cMaBO5FeZGKMLN9BW8ZoYS+c8Orr
         puRFij/HXeHT3vkxdR/5NMqJPshfysvZKfjdub0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 117/267] media: vimc: fix start stream when link is disabled
Date:   Mon, 16 Dec 2019 18:47:23 +0100
Message-Id: <20191216174903.116344651@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Fornazier <helen.koike@collabora.com>

[ Upstream commit e159b6074c82fe31b79aad672e02fa204dbbc6d8 ]

If link is disabled, media_entity_remote_pad returns NULL, causing a
NULL pointer deference.
Ignore links that are not enabled instead.

Signed-off-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 743554de724d8..a9ab3871ccda2 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -241,6 +241,8 @@ int vimc_pipeline_s_stream(struct media_entity *ent, int enable)
 
 		/* Start the stream in the subdevice direct connected */
 		pad = media_entity_remote_pad(&ent->pads[i]);
+		if (!pad)
+			continue;
 
 		if (!is_media_entity_v4l2_subdev(pad->entity))
 			return -EINVAL;
-- 
2.20.1



