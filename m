Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F32451FE3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355642AbhKPApo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343792AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 238266338F;
        Mon, 15 Nov 2021 18:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001977;
        bh=bn4B1iqs03nAu6fHpUSJchaPq3RWde9Xjd6oUJ4oq5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqL906tl3P+3N8hIN+TWGC5mqlFKSGjCaRZqmEOOTmlq+MEN64M37ervYZqYihD2I
         ULG4YuVO4tljTC4LSpb8kSa3fT2lFEgtKO0pCS/PZr3WiO5OAUOPfaMGT+eiWDSXVl
         TSXBX0PvaY7uF9yW5nU565CMfnZyr627+HDS8PxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/917] media: cx23885: Fix snd_card_free call on null card pointer
Date:   Mon, 15 Nov 2021 17:58:08 +0100
Message-Id: <20211115165442.093448052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 7266dda2f1dfe151b12ef0c14eb4d4e622fb211c ]

Currently a call to snd_card_new that fails will set card with a NULL
pointer, this causes a null pointer dereference on the error cleanup
path when card it passed to snd_card_free. Fix this by adding a new
error exit path that does not call snd_card_free and exiting via this
new path.

Addresses-Coverity: ("Explicit null dereference")

Fixes: 9e44d63246a9 ("[media] cx23885: Add ALSA support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-alsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index ab14d35214aa8..25dc8d4dc5b73 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -550,7 +550,7 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 			   SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
 			THIS_MODULE, sizeof(struct cx23885_audio_dev), &card);
 	if (err < 0)
-		goto error;
+		goto error_msg;
 
 	chip = (struct cx23885_audio_dev *) card->private_data;
 	chip->dev = dev;
@@ -576,6 +576,7 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 
 error:
 	snd_card_free(card);
+error_msg:
 	pr_err("%s(): Failed to register analog audio adapter\n",
 	       __func__);
 
-- 
2.33.0



