Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F7404E29
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbhIIMKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344145AbhIIMG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E7D615E2;
        Thu,  9 Sep 2021 11:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188049;
        bh=hXTmkclbLkPq43POKeL3I734PIXlNy0QX0S35lmmUX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7tUcVNO0dVQzW9HfiU8u37kH58dudE87dVDGvAaOp5qd8BrJRgwOdFVR6S6sg+1Z
         WIXAp/Qo98ryrb12OsGwF8LT5XDkI4R8P6nvK4ezIrA6KtHSXliNe+6OzvRASLRZPi
         /9EsrqdGBp803IpFw2OKEzvhOog1dDUmuxyquQVaCGiQazAVRiwauTp4TChUe+Gx+B
         DsH9d8lVV6HikeMHXy6JOcTRTXZLFHyMYNo42QzGeGqgULzEfUuHYFV76tkDTTeEhX
         njjxQcTCB6MKh0pbyavN3LNfRPrLuNCovmx/ATsEK5/xQK8tCW0u/VQXgtHotFiMGN
         NltgsxbgjO7YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 042/219] misc/pvpanic-pci: Allow automatic loading
Date:   Thu,  9 Sep 2021 07:43:38 -0400
Message-Id: <20210909114635.143983-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit 28b6a003bcdfa1fc4603b9185b247ecca7af9bef ]

The virtual machine monitor (QEMU) exposes the pvpanic-pci
device to the guest. On guest side the module exists but
currently isn't loaded automatically. So the driver fails
to be probed and does not its job of handling guest panic
events.

Instead of requiring manual modprobe, let's include a device
database using the MODULE_DEVICE_TABLE macro and let the
module auto-load when the guest gets exposed with such a
pvpanic-pci device.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20210629072214.901004-1-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 046ce4ecc195..4a3250564442 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -119,4 +119,6 @@ static struct pci_driver pvpanic_pci_driver = {
 	},
 };
 
+MODULE_DEVICE_TABLE(pci, pvpanic_pci_id_tbl);
+
 module_pci_driver(pvpanic_pci_driver);
-- 
2.30.2

