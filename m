Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9371C49924E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381109AbiAXUSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:18:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379844AbiAXUPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:15:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 190EEB81218;
        Mon, 24 Jan 2022 20:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20621C340E5;
        Mon, 24 Jan 2022 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055309;
        bh=WrCqZQRVcjEqYKrOwStT6HL75yR/zqNeI3M2IfBMBcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oXK0Dks5o/UTRomQV7qjT3PG3xyMNehpO5J+bPu9hCG+dxz2F5fLTmwH6MMdNkUq
         fbI9m6jssJq4Jn5jLhER6+6Ix5+uQz0OV/8g6LLDL7SLyUlEGHqZcpeJznIeU1cldL
         bW3TvbqeQN7zeslgZMomoNT420qroA+7N8nKgQ/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/846] media: atomisp: add missing media_device_cleanup() in atomisp_unregister_entities()
Date:   Mon, 24 Jan 2022 19:33:45 +0100
Message-Id: <20220124184104.708373363@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit ce3015b7212e96db426d0c36f80fd159c91155d1 ]

After the commit 9832e155f1ed ("[media] media-device: split media
initialization and registration"), calling media_device_cleanup()
is needed it seems. However, currently it is missing for the module
unload path.

Note that for the probe failure path, it is already added in
atomisp_register_entities().

This patch adds the missing call of media_device_cleanup() in
atomisp_unregister_entities().

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
index 1e324f1f656e5..0511c454e769d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
@@ -1182,6 +1182,7 @@ static void atomisp_unregister_entities(struct atomisp_device *isp)
 
 	v4l2_device_unregister(&isp->v4l2_dev);
 	media_device_unregister(&isp->media_dev);
+	media_device_cleanup(&isp->media_dev);
 }
 
 static int atomisp_register_entities(struct atomisp_device *isp)
-- 
2.34.1



