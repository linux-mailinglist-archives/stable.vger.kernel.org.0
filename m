Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342AE3BB12B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhGDXKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGDXKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE3B613D2;
        Sun,  4 Jul 2021 23:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440053;
        bh=Oc/muHyp/WkHhV5wU9XuA3AaY1FnzFrQ4sTl6k/RmDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy+P09zkzox1OU2k0obJ7e7X5Jrpp3+OKHbF6dmjA12lO8XxW4IePQuv2E4ho+ux+
         kt/eoAO60Fe3qxjYXP0rayRT2csyoPfKaSo2p9ADhQHxKwV2IAKd3UnSFVpK8P15y7
         ZFM009IreXtFRO30Ad6BBqlcJ+zzB4BiUGM2L9Lxk7AbPxCwDMnJw+P9t2bx5KxlZu
         rFK0fZLfpLEjDdha5nchPgbHVI3a5cblhXrS0Dd9xOoj5cqlqlQeNRWEwlotifBAiq
         tDpskfAKWQLjd4xgfS9gnrOYshMetCQIrrWYw6VT/cSSQRBa3DbfTq6mgDY9jDWWtG
         3f1rccUXmOCQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 57/80] media: dvbdev: fix error logic at dvb_register_device()
Date:   Sun,  4 Jul 2021 19:05:53 -0400
Message-Id: <20210704230616.1489200-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

