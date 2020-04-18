Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216361AED6E
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDRNtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgDRNtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:49:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6213422250;
        Sat, 18 Apr 2020 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217740;
        bh=x+3uj04gfbt089WFQK1mEWtg4dmCnvjijoKeHZ4uEF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bata/xkfEgJ8zrk2MkB6wCI8Bu/gLh3dBIqEZu3YkBYHTcPzZWmNE3R1BBAmOeLq
         Tn5I2LxuEPewoKKMuCLkK0A88kdulqRG5mPFbcqx6Puh9fbrscPR7qcGDGdDS0stcs
         FtVBfQqMfcgBmmSuME6gKOSEEt0P6mKh2VWOyM8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 35/73] s390/cio: generate delayed uevent for vfio-ccw subchannels
Date:   Sat, 18 Apr 2020 09:47:37 -0400
Message-Id: <20200418134815.6519-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

