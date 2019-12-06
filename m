Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88011514C
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfLFNtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:49:09 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:65230 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfLFNtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 08:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1575640149; x=1607176149;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yg/H4rYLdpjMh9EeUO9p3gNSwplJDxuqHR+8symDg3A=;
  b=LTEJgQ5tm4ht+lT8CsKEFqzJS0qYquI4zxI/w20qqP3SpfM3NV5wRvbh
   P/A1iDAI6KS00Jsa+VlZP6jQHfehrb1VBeKUKjh+Y+C8Tj3yHcvcxiY1o
   xsgUI9A+U41WJuh0f2QA6wzD8htECy+JNlj5NGq8zsyMyTEtYII4ET3a8
   c=;
IronPort-SDR: FjhXB9JqAJI6AnLIvtS0fINmoBUIYUcB+9FSmhw7O7H4zkwx4pPwr7ol9WV7YDYF8GNVE7iwSL
 9QljUSXCPItg==
X-IronPort-AV: E=Sophos;i="5.69,284,1571702400"; 
   d="scan'208";a="13388569"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Dec 2019 13:48:57 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 6334EA2BE3;
        Fri,  6 Dec 2019 13:48:56 +0000 (UTC)
Received: from EX13D07EUB004.ant.amazon.com (10.43.166.234) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 6 Dec 2019 13:48:55 +0000
Received: from u86a60e9fba0b55.ant.amazon.com (10.43.162.16) by
 EX13D07EUB004.ant.amazon.com (10.43.166.234) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 6 Dec 2019 13:48:51 +0000
From:   Stefan Nuernberger <snu@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Conny Seidel <consei@amazon.de>,
        Stefan Nuernberger <snu@amazon.com>,
        <xen-devel@lists.xenproject.org>, <stable@vger.kernel.org>
Subject: [PATCH] xen/pciback: Prevent NULL pointer dereference in quirks_show
Date:   Fri, 6 Dec 2019 14:48:04 +0100
Message-ID: <20191206134804.4537-1-snu@amazon.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-Originating-IP: [10.43.162.16]
X-ClientProxiedBy: EX13D04UWB004.ant.amazon.com (10.43.161.103) To
 EX13D07EUB004.ant.amazon.com (10.43.166.234)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Dannowski <uwed@amazon.de>

Reading /sys/bus/pci/drivers/pciback/quirks while unbinding can result
in dereferencing a NULL pointer. Instead, skip printing information
about the dangling quirk.

Reported-by: Conny Seidel <consei@amazon.de>
Signed-off-by: Uwe Dannowski <uwed@amazon.de>
Signed-off-by: Stefan Nuernberger <snu@amazon.com>

Cc: xen-devel@lists.xenproject.org
Cc: stable@vger.kernel.org
---
 drivers/xen/xen-pciback/pci_stub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 097410a7cdb7..da725e474294 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -1346,6 +1346,8 @@ static ssize_t quirks_show(struct device_driver *drv, char *buf)
 				   quirk->devid.subdevice);
 
 		dev_data = pci_get_drvdata(quirk->pdev);
+		if (!dev_data)
+			continue;
 
 		list_for_each_entry(cfg_entry, &dev_data->config_fields, list) {
 			field = cfg_entry->field;
-- 
2.23.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



