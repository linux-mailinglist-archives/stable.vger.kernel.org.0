Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BF21CAF9B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgEHNR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbgEHMnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4631224978;
        Fri,  8 May 2020 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941812;
        bh=rIvUnN0qPCeX6EYEn5S5OcwALRbUK6B/Lh0xuvzRDXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhzMWv7QRdBMuMilMOSZE25fttjVc+vzuuNep4gZLzCC+y5nH9O+k3/bJ2JkwBhl/
         4mDySXSs/bBJFRY75w3v6B4vCk5HwOmOPDdpaySVJIE0BZJsBumkU5M+6iiP8XHkgD
         o46bj6XiYwfEEgAPz4oUlCpBAWxeP17hzxcz9XVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 181/312] qlcnic: potential NULL dereference in qlcnic_83xx_get_minidump_template()
Date:   Fri,  8 May 2020 14:32:52 +0200
Message-Id: <20200508123137.216615221@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5f46feab87bb105d6a217d966b327fdc56696802 upstream.

If qlcnic_fw_cmd_get_minidump_temp() fails then "fw_dump->tmpl_hdr" is
NULL or possibly freed.  It can lead to an oops later.

Fixes: d01a6d3c8ae1 ('qlcnic: Add support to enable capability to extend minidump for iSCSI')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
@@ -1419,6 +1419,7 @@ void qlcnic_83xx_get_minidump_template(s
 	struct qlcnic_fw_dump *fw_dump = &ahw->fw_dump;
 	struct pci_dev *pdev = adapter->pdev;
 	bool extended = false;
+	int ret;
 
 	prev_version = adapter->fw_version;
 	current_version = qlcnic_83xx_get_fw_version(adapter);
@@ -1429,8 +1430,11 @@ void qlcnic_83xx_get_minidump_template(s
 		if (qlcnic_83xx_md_check_extended_dump_capability(adapter))
 			extended = !qlcnic_83xx_extend_md_capab(adapter);
 
-		if (!qlcnic_fw_cmd_get_minidump_temp(adapter))
-			dev_info(&pdev->dev, "Supports FW dump capability\n");
+		ret = qlcnic_fw_cmd_get_minidump_temp(adapter);
+		if (ret)
+			return;
+
+		dev_info(&pdev->dev, "Supports FW dump capability\n");
 
 		/* Once we have minidump template with extended iSCSI dump
 		 * capability, update the minidump capture mask to 0x1f as


