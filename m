Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F287813F8A5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437578AbgAPTUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731498AbgAPQyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF286214AF;
        Thu, 16 Jan 2020 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193645;
        bh=u9JD3C4YLpxJEKI/OEJ1TDTW/fEAkI4JriQ09cx7GO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRFkAxh1nRu99Tgg8wN2y7HgkY9U8bRTAMQCR7FjuROljy9EeeWSo0JtyzEDChhGT
         gna4Jrom3c2SmFzuF9jN25nE5LQD5FWJJCD10SrgDnwk25p+L4tMOjaHn2Abi2eEKg
         Ah6lZ+8ir9OfQ94gajIxOLnntY7LIzKRKeivauKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.co.uk>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 176/205] um: virtio_uml: Disallow modular build
Date:   Thu, 16 Jan 2020 11:42:31 -0500
Message-Id: <20200116164300.6705-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bf9f80cf0ccab5f346f7d3cdc445da8fcfe6ce34 ]

This driver *can* be a module, but then its parameters (socket path)
are untrusted data from inside the VM, and that isn't allowed. Allow
the code to only be built-in to avoid that.

Fixes: 5d38f324993f ("um: drivers: Add virtio vhost-user driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/Kconfig      | 2 +-
 arch/um/drivers/virtio_uml.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/Kconfig b/arch/um/drivers/Kconfig
index fea5a0d522dc..388096fb45a2 100644
--- a/arch/um/drivers/Kconfig
+++ b/arch/um/drivers/Kconfig
@@ -337,7 +337,7 @@ config UML_NET_SLIRP
 endmenu
 
 config VIRTIO_UML
-	tristate "UML driver for virtio devices"
+	bool "UML driver for virtio devices"
 	select VIRTIO
 	help
 	  This driver provides support for virtio based paravirtual device
diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index c5643a59a8c7..179b41ad63ba 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -4,12 +4,12 @@
  *
  * Copyright(c) 2019 Intel Corporation
  *
- * This module allows virtio devices to be used over a vhost-user socket.
+ * This driver allows virtio devices to be used over a vhost-user socket.
  *
  * Guest devices can be instantiated by kernel module or command line
  * parameters. One device will be created for each parameter. Syntax:
  *
- *		[virtio_uml.]device=<socket>:<virtio_id>[:<platform_id>]
+ *		virtio_uml.device=<socket>:<virtio_id>[:<platform_id>]
  * where:
  *		<socket>	:= vhost-user socket path to connect
  *		<virtio_id>	:= virtio device id (as in virtio_ids.h)
-- 
2.20.1

