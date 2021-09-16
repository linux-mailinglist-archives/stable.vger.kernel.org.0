Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC5840E71E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352818AbhIPR2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343974AbhIPR0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F9861A3C;
        Thu, 16 Sep 2021 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810702;
        bh=G6Y4ovkgtiaNKulr9qZGAnkDCbmrBJ7kEmwUDH2XY3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxxX4g4PhUFLyzsvaeeeIXjIPBMKn6gMxb81WCeoJdmaONWDjh0zrOUPTAXLH1b3y
         P1wogcsRoNpysvS6pKEWFZPaDZj05pvnwZU5vDR11gSC8H8EBU4xiVudR+RMrcaxhC
         Uy/pnh+PmyIiQL9clX1JZ2I3W8OOzssF9pN5acHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 204/432] misc/pvpanic-pci: Allow automatic loading
Date:   Thu, 16 Sep 2021 17:59:13 +0200
Message-Id: <20210916155817.733770834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a43c401017ae..741116b3d995 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -108,4 +108,6 @@ static struct pci_driver pvpanic_pci_driver = {
 	},
 };
 
+MODULE_DEVICE_TABLE(pci, pvpanic_pci_id_tbl);
+
 module_pci_driver(pvpanic_pci_driver);
-- 
2.30.2



