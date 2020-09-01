Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141B4259CB5
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgIARTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbgIAPNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90E9206EB;
        Tue,  1 Sep 2020 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973229;
        bh=mXVF9uRqoTaQC0cctmJegqY31LEmnQYv/Pi506+XALI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNUf/ONAgxmFMtMM3JjkxuqvJr5w7ErBK0/Mge32d4eJ1ZxS4gBXiIEJ1op+EWvUV
         NFBA+gm/lhAjtn2mtTdTKLiA/GhiRmGkzMBnipnPnuSL+KngFOwhjzop9XEfzT5U7J
         ZsI+3yh+DsaFlzo+/YdZ8mpxJsZ85EEszOwOAyGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/62] media: davinci: vpif_capture: fix potential double free
Date:   Tue,  1 Sep 2020 17:10:12 +0200
Message-Id: <20200901150922.185436441@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 602649eadaa0c977e362e641f51ec306bc1d365d ]

In case of errors vpif_probe_complete() releases memory for vpif_obj.sd
and unregisters the V4L2 device. But then this is done again by
vpif_probe() itself. The patch removes the cleaning from
vpif_probe_complete().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index c1e573b7cc6fb..50122ac2ac028 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1417,8 +1417,6 @@ probe_out:
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 	}
-	kfree(vpif_obj.sd);
-	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
 	return err;
 }
-- 
2.25.1



