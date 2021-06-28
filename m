Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0CC3B633B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhF1Ox3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235652AbhF1OvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:51:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B38F861D30;
        Mon, 28 Jun 2021 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891033;
        bh=xpSJH4nDIUttSvl+xD2dLa8v2e9SAFLNOnEpckpYODQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/h6WOFFwmZHKBZV/4/pjDB3hzvj3X9thGQxod08xy3SH4igf2wckrRcD+F6YvEOV
         ZHuJpUDqnaNPlAl9PRD05KXWoMpIkbAco2hNHH6XE2uKY3ZUXJEV3vHzNltu+ILJUh
         xOhCpAPF5/ppDuwaS1fSJvZSHh3YwnXGYKJOBB+6Q6lVskPh7Dm3w84gTUTtex6f6L
         7xd4CuO8RxdXs98uAlYI2G1iac4A3XL4IP9VNOjPdIYh+QQCP++19Pa+q6O0ixUXca
         JbTPcNNu6PipmywMyReUpY7sWSyomdvt97aWycZIRqB4qkelEbfVFfY0i0JFqAb3Bk
         oiTxCPsiko3yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shanker Donthineni <sdonthineni@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 50/88] PCI: Mark some NVIDIA GPUs to avoid bus reset
Date:   Mon, 28 Jun 2021 10:35:50 -0400
Message-Id: <20210628143628.33342-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index f0cd8f7ce881..de7d65971d7f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3389,6 +3389,18 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
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

