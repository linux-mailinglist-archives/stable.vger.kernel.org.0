Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AEB119BE7
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLJWMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbfLJWDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6E020637;
        Tue, 10 Dec 2019 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015421;
        bh=qPUpym6iprrBUL5VvWek+m8rHkTo/q5tSyLJ+Eaj+fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0bEFxzRGVUJ3lQsfqhQegwHA0YrkhYHmYkmkCXZWI9Ki+LQxgGMkUgewVcez6nUr
         NWC4zWJe0Qg0q6U5X3ntUq8T7pr8W5d+ozOKK/w3OLJtOdPR3SPr35ZJi0EGyRcOpP
         AoHvrxejC8xK5HDEKWZV6C2JbIji3zkWUXf32hao=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 033/130] media: cx88: Fix some error handling path in 'cx8800_initdev()'
Date:   Tue, 10 Dec 2019 17:01:24 -0500
Message-Id: <20191210220301.13262-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7d25ecd4404bf..1748812bd7e55 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1310,7 +1310,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	core = cx88_core_get(dev->pci);
 	if (!core) {
 		err = -EINVAL;
-		goto fail_free;
+		goto fail_disable;
 	}
 	dev->core = core;
 
@@ -1356,7 +1356,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 				       cc->step, cc->default_value);
 		if (!vc) {
 			err = core->audio_hdl.error;
-			goto fail_core;
+			goto fail_irq;
 		}
 		vc->priv = (void *)cc;
 	}
@@ -1370,7 +1370,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 				       cc->step, cc->default_value);
 		if (!vc) {
 			err = core->video_hdl.error;
-			goto fail_core;
+			goto fail_irq;
 		}
 		vc->priv = (void *)cc;
 		if (vc->id == V4L2_CID_CHROMA_AGC)
@@ -1533,11 +1533,14 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
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

