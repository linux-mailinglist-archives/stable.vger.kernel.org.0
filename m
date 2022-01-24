Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9561E4996B9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446019AbiAXVGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54492 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443904AbiAXU7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6126EB8121C;
        Mon, 24 Jan 2022 20:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8214FC340E5;
        Mon, 24 Jan 2022 20:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057969;
        bh=WrCqZQRVcjEqYKrOwStT6HL75yR/zqNeI3M2IfBMBcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYaS9rcwV8D3MSNY8ueFrt07jr54a2JozT6k8ZacJXfkm00N8x3EOusDjIvEMMY7k
         6WItLLCAD0+lXqPpqAFooG7XKIUSLYt40kdwg4Q7CwBKka4kXTrTPcVBs9YPsZglGd
         bv0zo+oEhc8TiE5FdLanLgoUwB7hWC5kODtf/Pec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0121/1039] media: atomisp: add missing media_device_cleanup() in atomisp_unregister_entities()
Date:   Mon, 24 Jan 2022 19:31:50 +0100
Message-Id: <20220124184129.203107110@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



