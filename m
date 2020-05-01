Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4F91C14B9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgEANm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730592AbgEANmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:42:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81627205C9;
        Fri,  1 May 2020 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340544;
        bh=9qMdGIHBfu8UAL3/kDkX7rnO57gJouswbtIyHkb7wmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCAWu7kjEzJ/2fLgogIat95n5rvZmKQ4hgQ5vVUL/AfllmXwYg4xpldpSVo12ooBo
         o5dXIiXyh+AZds8nIW3zp3SCp6qGTnVCSP+Ch4I9pnvAp+ge6vuYhUpctdOuMtmuNt
         QAt2M1VytE3uDuepCvBAnH+rv+0ZQbpuF431xDpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ann T Ropea <bedhanger@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.6 029/106] hwmon: (drivetemp) Use drivetemps true module name in Kconfig section
Date:   Fri,  1 May 2020 15:23:02 +0200
Message-Id: <20200501131547.479111909@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ann T Ropea <bedhanger@gmx.de>

commit 6bdf8f3efe867c5893e27431a555e41f54ed7f9a upstream.

The addition of the support for reading the temperature of ATA drives as
per commit 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives
with temperature sensors") lists in the respective Kconfig section the
name of the module to be optionally built as "satatemp".

However, building the kernel modules with "CONFIG_SENSORS_DRIVETEMP=m",
does not generate a file named "satatemp.ko".

Instead, the rest of the original commit uses the term "drivetemp" and
a file named "drivetemp.ko" ends up in the kernel's modules directory.
This file has the right ingredients:

	$ strings /path/to/drivetemp.ko | grep ^description
	description=Hard drive temperature monitor

and modprobing it produces the expected result:

	# drivetemp is not loaded
	$ sensors -u drivetemp-scsi-4-0
	Specified sensor(s) not found!
	$ sudo modprobe drivetemp
	$ sensors -u drivetemp-scsi-4-0
	drivetemp-scsi-4-0
	Adapter: SCSI adapter
	temp1:
	  temp1_input: 35.000
	  temp1_max: 60.000
	  temp1_min: 0.000
	  temp1_crit: 70.000
	  temp1_lcrit: -40.000
	  temp1_lowest: 20.000
	  temp1_highest: 36.000

Fix Kconfig by referring to the true name of the module.

Fixes: 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Signed-off-by: Ann T Ropea <bedhanger@gmx.de>
Link: https://lore.kernel.org/r/20200406235521.185309-1-bedhanger@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -403,7 +403,7 @@ config SENSORS_DRIVETEMP
 	  hard disk drives.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called satatemp.
+	  will be called drivetemp.
 
 config SENSORS_DS620
 	tristate "Dallas Semiconductor DS620"


