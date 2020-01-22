Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A99145671
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAVN0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbgAVN0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:54 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5FE2467B;
        Wed, 22 Jan 2020 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699613;
        bh=Ptih1HcvbYD2D0cVEP4/ui41M6xsgb9I+l94+a+B82I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wI8WR+Fd+PS518rnrEjm1iRhM91+uuPguvVySZNCDAOMy6lc+Zsmirtk8nODjPobl
         idvnyc29bdOyD9C6nfj6ngVWnqYRnVQP/0wHcvU83baMfnch6dS+tEf+7CCmLNVmf4
         Od1Tezk2NM8cTMpvkidypOD70FyAwyVs7zFCQC6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.co.uk>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 197/222] um: virtio_uml: Disallow modular build
Date:   Wed, 22 Jan 2020 10:29:43 +0100
Message-Id: <20200122092847.815724717@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit bf9f80cf0ccab5f346f7d3cdc445da8fcfe6ce34 upstream.

This driver *can* be a module, but then its parameters (socket path)
are untrusted data from inside the VM, and that isn't allowed. Allow
the code to only be built-in to avoid that.

Fixes: 5d38f324993f ("um: drivers: Add virtio vhost-user driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.co.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/drivers/Kconfig      |    2 +-
 arch/um/drivers/virtio_uml.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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


