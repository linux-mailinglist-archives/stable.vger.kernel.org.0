Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992C51BCA9F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgD1Sh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgD1Sh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:37:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F2520575;
        Tue, 28 Apr 2020 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099045;
        bh=JHaBNosCj1zG89vJZojwMlcYslKrzJGKsmuORnY+RAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqoJplVVfYvsO9zTY2X/BMAzTST2Szpuymo0Z8BRfbL+wjcCO/y9Wo7lS4tgiTI9L
         NxFWXdzHac6++B2tnMpS4/ltDg6p7aiMs+wKW2HDylRDjfSie7LxEafNMVWNw5YkbX
         5jqocjxKmZZHj0sCfgc1SDgyK/zVAb5rUATD3xTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>,
        Wu Hao <hao.wu@intel.com>, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.6 148/167] fpga: dfl: pci: fix return value of cci_pci_sriov_configure
Date:   Tue, 28 Apr 2020 20:25:24 +0200
Message-Id: <20200428182244.291758805@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

commit 3c2760b78f90db874401d97e3c17829e2e36f400 upstream.

pci_driver.sriov_configure should return negative value on error and
number of enabled VFs on success. But now the driver returns 0 on
success. The sriov configure still works but will cause a warning
message:

  XX VFs requested; only 0 enabled

This patch changes the return value accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/fpga/dfl-pci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/fpga/dfl-pci.c
+++ b/drivers/fpga/dfl-pci.c
@@ -248,11 +248,13 @@ static int cci_pci_sriov_configure(struc
 			return ret;
 
 		ret = pci_enable_sriov(pcidev, num_vfs);
-		if (ret)
+		if (ret) {
 			dfl_fpga_cdev_config_ports_pf(cdev);
+			return ret;
+		}
 	}
 
-	return ret;
+	return num_vfs;
 }
 
 static void cci_pci_remove(struct pci_dev *pcidev)


