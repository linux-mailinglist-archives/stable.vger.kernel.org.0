Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB7D3C51BA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344351AbhGLHnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347703AbhGLHkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA2F961482;
        Mon, 12 Jul 2021 07:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075337;
        bh=Oc/muHyp/WkHhV5wU9XuA3AaY1FnzFrQ4sTl6k/RmDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjYEEhTDY+JP+a0IbmGdSJpo1hc19pE+unQAHieELgypy+v0NfwUs8DkvtO9hRNor
         Ota6eafNTEPQKUKYqr9JhBzTdNjwvTdd2GmgQYE4EqS3mQJ2AMhxhMm/WAlWxP8Uzs
         pCTkPgUUlvPBf3R5NKwkMG1wZ0pP6y1/B5ehmEvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 185/800] media: dvbdev: fix error logic at dvb_register_device()
Date:   Mon, 12 Jul 2021 08:03:28 +0200
Message-Id: <20210712060939.065588098@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 1fec2ecc252301110e4149e6183fa70460d29674 ]

As reported by smatch:

	drivers/media/dvb-core/dvbdev.c: drivers/media/dvb-core/dvbdev.c:510 dvb_register_device() warn: '&dvbdev->list_head' not removed from list
	drivers/media/dvb-core/dvbdev.c: drivers/media/dvb-core/dvbdev.c:530 dvb_register_device() warn: '&dvbdev->list_head' not removed from list
	drivers/media/dvb-core/dvbdev.c: drivers/media/dvb-core/dvbdev.c:545 dvb_register_device() warn: '&dvbdev->list_head' not removed from list

The error logic inside dvb_register_device() doesn't remove
devices from the dvb_adapter_list in case of errors.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 3862ddc86ec4..795d9bfaba5c 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -506,6 +506,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			break;
 
 	if (minor == MAX_DVB_MINORS) {
+		list_del (&dvbdev->list_head);
 		kfree(dvbdevfops);
 		kfree(dvbdev);
 		up_write(&minor_rwsem);
@@ -526,6 +527,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		      __func__);
 
 		dvb_media_device_free(dvbdev);
+		list_del (&dvbdev->list_head);
 		kfree(dvbdevfops);
 		kfree(dvbdev);
 		mutex_unlock(&dvbdev_register_lock);
@@ -541,6 +543,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		pr_err("%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		dvb_media_device_free(dvbdev);
+		list_del (&dvbdev->list_head);
 		kfree(dvbdevfops);
 		kfree(dvbdev);
 		return PTR_ERR(clsdev);
-- 
2.30.2



