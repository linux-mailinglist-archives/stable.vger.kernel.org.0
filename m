Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2243B6455
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbhF1PG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237232AbhF1PF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3D561C93;
        Mon, 28 Jun 2021 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891407;
        bh=N0KB+j/5MHXPBDOXieO7igeQjIyk5FpsLSOt5rjYaC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8bSuqMaJNMoTVVOk6RfaI8PrVTK/RLRx9NMGb/CVGApFDSrMkhYTxU8+e0FiIt7d
         ABBGxmkKEx1n0hJLiLCkOnkZ4ectJP4T+M8svH62V16vrxnefD0xb9RwUkLb6RZmz2
         JAwBFmLnVX2qqBG2sjRqpdd2KNjrcaiV+L1WXj30bOa5xH99tNUTQs9pF9IZO9GGtW
         Tv9fJzuHNPEG+3JTTgiRQK9E3+vN207kCeyQiTcHJwBfW5uAhIpnyPzL2UvI+9tEcQ
         aziGmhFT218m5Ra6I5I9vEGuYQYiA81msZOWi+ImcQEB8THTvVR3fxKB9Kr7UyvX76
         JlAuQgaFWpKJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shanker Donthineni <sdonthineni@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 34/57] PCI: Mark some NVIDIA GPUs to avoid bus reset
Date:   Mon, 28 Jun 2021 10:42:33 -0400
Message-Id: <20210628144256.34524-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit 4c207e7121fa92b66bf1896bf8ccb9edfb0f9731 upstream.

Some NVIDIA GPU devices do not work with SBR.  Triggering SBR leaves the
device inoperable for the current system boot. It requires a system
hard-reboot to get the GPU device back to normal operating condition
post-SBR. For the affected devices, enable NO_BUS_RESET quirk to avoid the
issue.

This issue will be fixed in the next generation of hardware.

Link: https://lore.kernel.org/r/20210608054857.18963-8-ameynarkhede03@gmail.com
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d6199776c0f6..e65eec0644a7 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3144,6 +3144,18 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
 }
 
+/*
+ * Some NVIDIA GPU devices do not work with bus reset, SBR needs to be
+ * prevented for those affected devices.
+ */
+static void quirk_nvidia_no_bus_reset(struct pci_dev *dev)
+{
+	if ((dev->device & 0xffc0) == 0x2340)
+		quirk_no_bus_reset(dev);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			 quirk_nvidia_no_bus_reset);
+
 /*
  * Some Atheros AR9xxx and QCA988x chips do not behave after a bus reset.
  * The device will throw a Link Down error on AER-capable systems and
-- 
2.30.2

