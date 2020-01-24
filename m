Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102ED147D30
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgAXJ5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:57:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgAXJ5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:57:49 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F02B72075D;
        Fri, 24 Jan 2020 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859868;
        bh=TglLThL9C2K27x17ojg4aldkA5gw9U2fS53Vch6q/yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHgXuz3tLeLV58G0s4EPFxTo+ZrdYkQ6Db+Z4ejRCStmL0VIr/X5eNQ2Cef1K+UQo
         ViBsby38Z+NHx9BC5t9BIX5CP1U8PUpX9hOFNwUTNAkQ1HsN1Gp4SwjtmjnXsZoXmz
         rDK8iA+apvv6XP8yp0Lqn73xmCo4pNtyfMM0QYMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 200/343] media: davinci/vpbe: array underflow in vpbe_enum_outputs()
Date:   Fri, 24 Jan 2020 10:30:18 +0100
Message-Id: <20200124092946.267908563@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 1d3c13e369044..915af9ca47111 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -126,7 +126,7 @@ static int vpbe_enum_outputs(struct vpbe_device *vpbe_dev,
 			     struct v4l2_output *output)
 {
 	struct vpbe_config *cfg = vpbe_dev->cfg;
-	int temp_index = output->index;
+	unsigned int temp_index = output->index;
 
 	if (temp_index >= cfg->num_outputs)
 		return -EINVAL;
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 79a566d7defd0..180a05e914979 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -92,7 +92,7 @@ struct vpbe_config {
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



