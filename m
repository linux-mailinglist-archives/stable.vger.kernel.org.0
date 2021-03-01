Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A2432845A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhCAQdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:33:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234854AbhCAQ3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1778664F4C;
        Mon,  1 Mar 2021 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615767;
        bh=h5ID4jmO0po2Uhe8PSiE3HsJUspz43kDkKDsUio43LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRRBOxUKETUSnJt88wtsCBXEG7LoTiGfJHLeX+qWXzdDXezeONyrXw7UNsYlCDgIL
         PyjM+ISNQIbl0C70ULJcRc+slpkSpxckOljl/0+Epx6bEn9WMif1yVuN1b8msJ6eik
         wv5J9/rvume+vHdBz2L4HkFF/5WjzMXOWbsJh8Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 035/134] media: media/pci: Fix memleak in empress_init
Date:   Mon,  1 Mar 2021 17:12:16 +0100
Message-Id: <20210301161015.309137880@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 15d0c52241ecb1c9d802506bff6f5c3f7872c0df ]

When vb2_queue_init() fails, dev->empress_dev
should be released just like other error handling
paths.

Fixes: 2ada815fc48bb ("[media] saa7134: convert to vb2")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index f0fe2524259f0..522e1e18850fb 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -297,8 +297,11 @@ static int empress_init(struct saa7134_dev *dev)
 	q->lock = &dev->lock;
 	q->dev = &dev->pci->dev;
 	err = vb2_queue_init(q);
-	if (err)
+	if (err) {
+		video_device_release(dev->empress_dev);
+		dev->empress_dev = NULL;
 		return err;
+	}
 	dev->empress_dev->queue = q;
 
 	video_set_drvdata(dev->empress_dev, dev);
-- 
2.27.0



