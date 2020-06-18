Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6CD1FDE20
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbgFRBa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732658AbgFRBa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:30:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4C520773;
        Thu, 18 Jun 2020 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443857;
        bh=P8963dETUzX8bx+UivL9M//VUnGMxCoatVm12LOeroY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q06kGMDXuWEIDj2jf0i7U7KDeeD33FH8FmysHchASxImM09QVca/5zlX2Od1UoqDD
         xV+LYpmFXJZcj68xdf4V0GJznlUfTzfVT4/swnG8c44cTU1MXRn8w87KfdjNshwRah
         NfJqr16HiHz82dxbW5NMso8LNK3KcOo6wVUuiOB8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 40/60] vfio-pci: Mask cap zero
Date:   Wed, 17 Jun 2020 21:29:44 -0400
Message-Id: <20200618013004.610532-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618013004.610532-1-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit bc138db1b96264b9c1779cf18d5a3b186aa90066 ]

The PCI Code and ID Assignment Specification changed capability ID 0
from reserved to a NULL capability in the v1.1 revision.  The NULL
capability is defined to include only the 16-bit capability header,
ie. only the ID and next pointer.  Unfortunately vfio-pci creates a
map of config space, where ID 0 is used to reserve the standard type
0 header.  Finding an actual capability with this ID therefore results
in a bogus range marked in that map and conflicts with subsequent
capabilities.  As this seems to be a dummy capability anyway and we
already support dropping capabilities, let's hide this one rather than
delving into the potentially subtle dependencies within our map.

Seen on an NVIDIA Tesla T4.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index bf65572f47a8..666b234acca0 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1405,7 +1405,12 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 		if (ret)
 			return ret;
 
-		if (cap <= PCI_CAP_ID_MAX) {
+		/*
+		 * ID 0 is a NULL capability, conflicting with our fake
+		 * PCI_CAP_ID_BASIC.  As it has no content, consider it
+		 * hidden for now.
+		 */
+		if (cap && cap <= PCI_CAP_ID_MAX) {
 			len = pci_cap_length[cap];
 			if (len == 0xFF) { /* Variable length */
 				len = vfio_cap_len(vdev, cap, pos);
-- 
2.25.1

