Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97055411D40
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348155AbhITRRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245173AbhITRPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 517A461211;
        Mon, 20 Sep 2021 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157124;
        bh=xGwExUppbd3H53PxpNT/Y7MZXZdRKAOroOEcEFe8Yis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJLsa3WpulPQJe5+RP8n/gtj6TGYAkKFbpMVSv/xziVuX8bNPTQovOc9uY47Cnwi5
         vQA/vjnIPppPG0SiJwti94lCnA34LBIqv4A3nDs0TTYB2uyNKNUkYM2BucVciU1k6n
         2LH8f2AmMSH68TQX0sA51xxH0GbIzMCijBdIGoTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/217] s390/cio: add dev_busid sysfs entry for each subchannel
Date:   Mon, 20 Sep 2021 18:40:58 +0200
Message-Id: <20210920163925.892338560@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e2026d54dd37..435e804b6b8b 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -330,9 +330,26 @@ static ssize_t pimpampom_show(struct device *dev,
 }
 static DEVICE_ATTR(pimpampom, 0444, pimpampom_show, NULL);
 
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



