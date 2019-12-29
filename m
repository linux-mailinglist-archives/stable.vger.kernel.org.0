Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87D912C65C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbfL2RqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbfL2RqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFA4208C4;
        Sun, 29 Dec 2019 17:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641574;
        bh=UALRAfUb1syHf2cxpcr7GQZ6l1xgsNRJ/e5U2pJ/Lpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daOYvj3V5HEfWxBw81K2oaHB+qy+Dl0NaiSXdCjLFf3Ud8AeK4bzqEDv7LSklSYaB
         brzQBYFAnEf0Sde7Pta4mfdkQZtjZwDNx3/LY6M/FMS2UIYJojt1B6SGUV39cjCAHF
         DA/+NRGUkhXuIYDZcQQokEimskSGLP/f6QqxZmCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/434] media: cx88: Fix some error handling path in cx8800_initdev()
Date:   Sun, 29 Dec 2019 18:22:55 +0100
Message-Id: <20191229172709.798597690@linuxfoundation.org>
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

[ Upstream commit e1444e9b0424c70def6352580762d660af50e03f ]

A call to 'pci_disable_device()' is missing in the error handling path.
In some cases, a call to 'free_irq()' may also be missing.

Reorder the error handling path, add some new labels and fix the 2 issues
mentionned above.

This way, the error handling path in more in line with 'cx8800_finidev()'
(i.e. the remove function)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-video.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index dcc0f02aeb70..b8abcd550604 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1277,7 +1277,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	core = cx88_core_get(dev->pci);
 	if (!core) {
 		err = -EINVAL;
-		goto fail_free;
+		goto fail_disable;
 	}
 	dev->core = core;
 
@@ -1323,7 +1323,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 				       cc->step, cc->default_value);
 		if (!vc) {
 			err = core->audio_hdl.error;
-			goto fail_core;
+			goto fail_irq;
 		}
 		vc->priv = (void *)cc;
 	}
@@ -1337,7 +1337,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 				       cc->step, cc->default_value);
 		if (!vc) {
 			err = core->video_hdl.error;
-			goto fail_core;
+			goto fail_irq;
 		}
 		vc->priv = (void *)cc;
 		if (vc->id == V4L2_CID_CHROMA_AGC)
@@ -1509,11 +1509,14 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 fail_unreg:
 	cx8800_unregister_video(dev);
-	free_irq(pci_dev->irq, dev);
 	mutex_unlock(&core->lock);
+fail_irq:
+	free_irq(pci_dev->irq, dev);
 fail_core:
 	core->v4ldev = NULL;
 	cx88_core_put(core, dev->pci);
+fail_disable:
+	pci_disable_device(pci_dev);
 fail_free:
 	kfree(dev);
 	return err;
-- 
2.20.1



