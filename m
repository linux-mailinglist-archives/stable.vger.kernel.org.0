Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD64E14BB30
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgA1OoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgA1OKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:10:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECE1424688;
        Tue, 28 Jan 2020 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220639;
        bh=Tub63oqi66lFA0AvcS+l6T0/NfRFI42oADpT38jkzjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTR8SB45PN5XgXrBomzEgPKhWb+/2LRyjoc07Y0td00vtnyCvlmZPLJngkbouBrKV
         /2Wn0nuv3NN0GdcRswk1irr0cXLeJvcvL0AIhUFsgbdRZEYjavGIORkYP191rpPIHa
         Oc7nCF7/X/GX+ANNKM887tAEYbeUMVMhhySWEVNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 088/183] media: davinci/vpbe: array underflow in vpbe_enum_outputs()
Date:   Tue, 28 Jan 2020 15:05:07 +0100
Message-Id: <20200128135838.824562971@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b72845ee5577b227131b1fef23f9d9a296621d7b ]

In vpbe_enum_outputs() we check if (temp_index >= cfg->num_outputs) but
the problem is that "temp_index" can be negative.  This patch changes
the types to unsigned to address this array underflow bug.

Fixes: 66715cdc3224 ("[media] davinci vpbe: VPBE display driver")

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpbe.c | 2 +-
 include/media/davinci/vpbe.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index abce9c4a1a8ec..59518c08528b8 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -130,7 +130,7 @@ static int vpbe_enum_outputs(struct vpbe_device *vpbe_dev,
 			     struct v4l2_output *output)
 {
 	struct vpbe_config *cfg = vpbe_dev->cfg;
-	int temp_index = output->index;
+	unsigned int temp_index = output->index;
 
 	if (temp_index >= cfg->num_outputs)
 		return -EINVAL;
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 4376beeb28c2c..5d8ceeddc7973 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -96,7 +96,7 @@ struct vpbe_config {
 	struct encoder_config_info *ext_encoders;
 	/* amplifier information goes here */
 	struct amp_config_info *amp;
-	int num_outputs;
+	unsigned int num_outputs;
 	/* Order is venc outputs followed by LCD and then external encoders */
 	struct vpbe_output *outputs;
 };
-- 
2.20.1



