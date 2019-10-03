Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A39CA4F7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390989AbfJCQ3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390581AbfJCQ3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 391E720700;
        Thu,  3 Oct 2019 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120184;
        bh=wDcK0SuxOI7PvWtcKRyhb1YAeAPrSWo4zVxce4QENGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YydILQtIrXkRxj8JYBXW7WKqbK2MDzjR9SS7GVWbmFIqKKqnVcOn0nbUzUM0opX4D
         OBiixFKfVcutp7FP1MRCi0gk7O3/MQmh66emcHcBJ6s/oAjit/JMn8BGPhjN+25Xwx
         /kIPjqXagSEZbpMdy5kMXtFunglflnmR0U49OO3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 129/313] media: dvb-core: fix a memory leak bug
Date:   Thu,  3 Oct 2019 17:51:47 +0200
Message-Id: <20191003154545.606590334@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit fcd5ce4b3936242e6679875a4d3c3acfc8743e15 ]

In dvb_create_media_entity(), 'dvbdev->entity' is allocated through
kzalloc(). Then, 'dvbdev->pads' is allocated through kcalloc(). However, if
kcalloc() fails, the allocated 'dvbdev->entity' is not deallocated, leading
to a memory leak bug. To fix this issue, free 'dvbdev->entity' before
returning -ENOMEM.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index a3393cd4e584f..7557fbf9d3068 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -339,8 +339,10 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 	if (npads) {
 		dvbdev->pads = kcalloc(npads, sizeof(*dvbdev->pads),
 				       GFP_KERNEL);
-		if (!dvbdev->pads)
+		if (!dvbdev->pads) {
+			kfree(dvbdev->entity);
 			return -ENOMEM;
+		}
 	}
 
 	switch (type) {
-- 
2.20.1



