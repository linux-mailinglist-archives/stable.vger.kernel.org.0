Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E259040129D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhIFBVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238638AbhIFBV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80C8C610E8;
        Mon,  6 Sep 2021 01:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891222;
        bh=CsjYALVIpDrXms1/IH5MyVOgUNBA0DQFj67fi+aflx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8eGVhsCfxes/DIqEzcJ8QNaOHOuI6u6DDNS529d3PzTiJ8tr/niAVW7qKoGt4Fou
         HyCwrhRJIn6bGYJyKaIi3hBUvBqZa1WK7Ui9mtOaffnaP879C8CAVkLCDnon6mFY9i
         1N+CQBw0Ar0kViu0dE3fE7FaZYsD4PwTxBv+wpRlwB6G8h8PROT9uTolWFQfCNLEYM
         JqTILcnnC8pb59DF8OCFWjS7j9VnRQJ4+WFiwrgQdLceqXHp/s5FWgvTDHignDSo7f
         MhTSWkes8Mjn2c+GNDBCvFdspy2Qv3etFTNQtkl50FzqchpazEZQ8SMQoLinPWxqcN
         Eb334xoRAW//Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 25/47] s390/cio: add dev_busid sysfs entry for each subchannel
Date:   Sun,  5 Sep 2021 21:19:29 -0400
Message-Id: <20210906011951.928679-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
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
index a974943c27da..9fcdb8d81eee 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -430,9 +430,26 @@ static ssize_t pimpampom_show(struct device *dev,
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

