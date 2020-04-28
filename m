Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636421BCAF1
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgD1Sxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730191AbgD1SfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA540217D8;
        Tue, 28 Apr 2020 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098903;
        bh=x+3uj04gfbt089WFQK1mEWtg4dmCnvjijoKeHZ4uEF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Avq1cB4Qh/L6k+wiyfQRT4UPM0hVHlqNuYp/I22xmmXk8KnZj5MOJd65fIyiy0aao
         7coWZWb9TP1L+zfdctp0saVGLIjlgZWIwYF61T9XxBcCQLE94LwJ7VKM+2Zkdlf6Xr
         eWSI3F6tbaQJFCrGOYLHihB5NKnijVt/P9nrupX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/168] s390/cio: generate delayed uevent for vfio-ccw subchannels
Date:   Tue, 28 Apr 2020 20:23:23 +0200
Message-Id: <20200428182235.413040677@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cornelia Huck <cohuck@redhat.com>

[ Upstream commit 2bc55eaeb88d30accfc1b6ac2708d4e4b81ca260 ]

The common I/O layer delays the ADD uevent for subchannels and
delegates generating this uevent to the individual subchannel
drivers. The vfio-ccw I/O subchannel driver, however, did not
do that, and will not generate an ADD uevent for subchannels
that had not been bound to a different driver (or none at all,
which also triggers the uevent).

Generate the ADD uevent at the end of the probe function if
uevents were still suppressed for the device.

Message-Id: <20200327124503.9794-3-cohuck@redhat.com>
Fixes: 63f1934d562d ("vfio: ccw: basic implementation for vfio_ccw driver")
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index e401a3d0aa570..339a6bc0339b0 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -167,6 +167,11 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	if (ret)
 		goto out_disable;
 
+	if (dev_get_uevent_suppress(&sch->dev)) {
+		dev_set_uevent_suppress(&sch->dev, 0);
+		kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
+	}
+
 	VFIO_CCW_MSG_EVENT(4, "bound to subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
-- 
2.20.1



