Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D5617FDB0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgCJMvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbgCJMvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FAC2468E;
        Tue, 10 Mar 2020 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844704;
        bh=kNqg7uePm2vq1Lh6+cc4u5zajUhmI7rnSFTD2vc+6ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piyE8adKoo8PHI0Paz/AE/BslPpljFmyU2J5BYEQ3U5NBgocAsaU2nOETobQRvmrp
         Hu+06ZG4MMAKJM9kwsI0EG8ZN4vQazHRKIsVBzHGP8lnZyP+P4HcujEMwSZw1O935Z
         86LzN0oPA/aEV4ZNpsT7xWc4ppNjyHJKao3bgD0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 088/168] media: hantro: Fix broken media controller links
Date:   Tue, 10 Mar 2020 13:38:54 +0100
Message-Id: <20200310123644.175528961@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

commit d171c45da874e3858a83e6377e00280a507fe2f2 upstream.

The driver currently creates a broken topology,
with a source-to-source link and a sink-to-sink
link instead of two source-to-sink links.

Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: <stable@vger.kernel.org>      # for v5.3 and up
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -553,13 +553,13 @@ static int hantro_attach_func(struct han
 		goto err_rel_entity1;
 
 	/* Connect the three entities */
-	ret = media_create_pad_link(&func->vdev.entity, 0, &func->proc, 1,
+	ret = media_create_pad_link(&func->vdev.entity, 0, &func->proc, 0,
 				    MEDIA_LNK_FL_IMMUTABLE |
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		goto err_rel_entity2;
 
-	ret = media_create_pad_link(&func->proc, 0, &func->sink, 0,
+	ret = media_create_pad_link(&func->proc, 1, &func->sink, 0,
 				    MEDIA_LNK_FL_IMMUTABLE |
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)


