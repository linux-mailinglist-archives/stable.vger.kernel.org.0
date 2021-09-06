Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8974013A0
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241063AbhIFB1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240472AbhIFBZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 403F26113C;
        Mon,  6 Sep 2021 01:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891343;
        bh=5rleiisEq+XyVmQ7RxgaVx7q1iFSXMHn9eJxCAABnI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGGLb9uSuHtbMT36g13h8cY4HYIpiwrwUMvMfS0Ua/9Sj2a/yRSWBwncXcEtEjJ/z
         4CRykcMMGjKZwDzTj9l9uFBKl0UPRuB9xo1OwA6cHPPuHYC5IdIp1DuZJV2zTXF/rP
         w/2QiR1bqakfifMXbFZVxd34MS4f4vRhwT47p3f9PurPEiAvXZBVoEzg/80QPo+Tt8
         LWICZIPFykJlQjJMCd2Hh6ncY6zQxnNPF3PbI+wG3BYhf7j/ym/iY3nzyNWQ4Rvnb1
         RuXHO7dvVNyn4k5J4Lx/UwqDF9Ccyp07d2pmxrdQ5hrzOAURiqcGtYCh5RjFztS2YW
         /ZIKWJ8jNXy7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/39] s390/cio: add dev_busid sysfs entry for each subchannel
Date:   Sun,  5 Sep 2021 21:21:38 -0400
Message-Id: <20210906012153.929962-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit d3683c055212bf910d4e318f7944910ce10dbee6 ]

Introduce dev_busid, which exports the device-id associated with the
io-subchannel (and message-subchannel). The dev_busid indicates that of
the device which may be physically installed on the corrosponding
subchannel. The dev_busid value "none" indicates that the subchannel
is not valid, there is no I/O device currently associated with the
subchannel.

The dev_busid information would be helpful to write device-specific
udev-rules associated with the subchannel. The dev_busid interface would
be available even when the sch is not bound to any driver or if there is
no operational device connected on it. Hence this attribute can be used to
write udev-rules which are specific to the device associated with the
subchannel.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index cca1a7c4bb33..305db4173dcf 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -426,9 +426,26 @@ static ssize_t pimpampom_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(pimpampom);
 
+static ssize_t dev_busid_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct subchannel *sch = to_subchannel(dev);
+	struct pmcw *pmcw = &sch->schib.pmcw;
+
+	if ((pmcw->st == SUBCHANNEL_TYPE_IO ||
+	     pmcw->st == SUBCHANNEL_TYPE_MSG) && pmcw->dnv)
+		return sysfs_emit(buf, "0.%x.%04x\n", sch->schid.ssid,
+				  pmcw->dev);
+	else
+		return sysfs_emit(buf, "none\n");
+}
+static DEVICE_ATTR_RO(dev_busid);
+
 static struct attribute *io_subchannel_type_attrs[] = {
 	&dev_attr_chpids.attr,
 	&dev_attr_pimpampom.attr,
+	&dev_attr_dev_busid.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(io_subchannel_type);
-- 
2.30.2

