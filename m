Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9DA49A3C0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368780AbiAYAAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846533AbiAXXQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077FDC07E5FE;
        Mon, 24 Jan 2022 11:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994D6612E9;
        Mon, 24 Jan 2022 19:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C1DC340E5;
        Mon, 24 Jan 2022 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053443;
        bh=TUZoR2a6e6D4ye3CC8JKRwNZAcvr5X0v2R8sXMbQqKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7t7JzNi4kgFqKQroBRWprrk15DOxcSmYhvqGLc+aNm0DfejS9RtsgBFlL1dYLcN7
         95ahyGvyZoA4rS1VG2wBjJh9QI4jjChyZ/RoO2G6piUER2C2yfLElyjQyJghLiBbAD
         b3f+zB5hTFmch+fiDlp/CIMH25o+31XBNp/JU5cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/563] media: atomisp: add missing media_device_cleanup() in atomisp_unregister_entities()
Date:   Mon, 24 Jan 2022 19:37:10 +0100
Message-Id: <20220124184026.656495527@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index fa1bd99cd6f17..d35506f643609 100644
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



