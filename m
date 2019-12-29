Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B3B12C79C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbfL2RoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbfL2RoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63157206A4;
        Sun, 29 Dec 2019 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641461;
        bh=4TdLhCm98y6W11kO/gpRHN9sI3ZrL8C426293eUQ7OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCfL/3SxoUHfW6nAmU+zCha0IUl66ebR8jEzdWOcSVP+eYyIg/OfTaD1Lkj7rvptN
         06760A+hAscTvI6ZzJYgDCr1cfNCUad50pgn8Ilrt7pj9EwUrxAC0S5Q41BKCCl2cs
         KFhZ+PJQhCrx3zL4afRLhjU5G9v6qMt9p9LD3avE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/434] media: seco-cec: Add a missing release_region() in an error handling path
Date:   Sun, 29 Dec 2019 18:22:09 +0100
Message-Id: <20191229172706.674146529@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a9cc4cbcdfd378b65fd4e398800cfa14e3855042 ]

At the beginning of the probe function, we have a call to
'request_muxed_region(BRA_SMB_BASE_ADDR, 7, "CEC00001")()'

A corresponding 'release_region()' is performed in the remove function but
is lacking in the error handling path.

Add it.

Fixes: b03c2fb97adc ("media: add SECO cec driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/seco-cec/seco-cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/seco-cec/seco-cec.c b/drivers/media/platform/seco-cec/seco-cec.c
index 9cd60fe1867c..a86b6e8f9196 100644
--- a/drivers/media/platform/seco-cec/seco-cec.c
+++ b/drivers/media/platform/seco-cec/seco-cec.c
@@ -675,6 +675,7 @@ err_notifier:
 err_delete_adapter:
 	cec_delete_adapter(secocec->cec_adap);
 err:
+	release_region(BRA_SMB_BASE_ADDR, 7);
 	dev_err(dev, "%s device probe failed\n", dev_name(dev));
 
 	return ret;
-- 
2.20.1



