Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80659404A1F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhIILou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236641AbhIILnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9023D6120E;
        Thu,  9 Sep 2021 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187730;
        bh=G6Y4ovkgtiaNKulr9qZGAnkDCbmrBJ7kEmwUDH2XY3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ0PK+BUoEjpHHZ495YNzjqvWvs90aUjLAbXVIeoG7JfhJehJYvVmrBuGJu5F8sNO
         eeeINWwym2nYa9Lk8WaexxzQTGGAcmJ3heYlctkWjC4XckfEZcAnknoXcJWV1x3LMR
         8/yaTVSFtrm7+5Tv9EUnNUt1qxWrfY7Bc+KxZWhbDHKYhkbPDDxNajjWloEEQ+onFj
         wQejFODBFumxO2v25tQXKDYwWfpz7vmGrSfQmsLkfVW7I2u9GASHrwWTNn5JZt4a47
         R018zjuvnjdt3DFx60TEqMYW+sTEcn8dqa5HbaYgglf9Ib8HKND7faArTFdb38p627
         VKG+dlC8AUU/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 050/252] misc/pvpanic-pci: Allow automatic loading
Date:   Thu,  9 Sep 2021 07:37:44 -0400
Message-Id: <20210909114106.141462-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

