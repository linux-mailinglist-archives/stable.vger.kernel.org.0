Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE637C581
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhELPlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235710AbhELPgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F02F61108;
        Wed, 12 May 2021 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832683;
        bh=Ip3zgyeZub5VEfzgBL6PdRbTF4F0CsaZQvfLmEkXS0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZIM/kKM6LcP9u3kXyTI2NX4Ke7WpfQ1piHhgRz30ofPq/KsgfNvAmNo2lsVgQSrU
         WlL9VqhCjyBorw8wZLwxPySdMv6BYwV9ih8oaG2u/2y2z8iVAbwRx1UEQ8Gjvj3E/M
         B2WsWiqPlh9LvghJnlk7sUE6V/pfO6dwrzS2aqdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/530] powerpc/pseries: Only register vio drivers if vio bus exists
Date:   Wed, 12 May 2021 16:48:11 +0200
Message-Id: <20210512144832.295961264@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 11d92156f7a862091009d7655d19c1e7de37fc7a ]

The vio bus is a fake bus, which we use on pseries LPARs (guests) to
discover devices provided by the hypervisor. There's no need or sense
in creating the vio bus on bare metal systems.

Which is why commit 4336b9337824 ("powerpc/pseries: Make vio and
ibmebus initcalls pseries specific") made the initialisation of the
vio bus only happen in LPARs.

However as a result of that commit we now see errors at boot on bare
metal systems:

  Driver 'hvc_console' was unable to register with bus_type 'vio' because the bus was not initialized.
  Driver 'tpm_ibmvtpm' was unable to register with bus_type 'vio' because the bus was not initialized.

This happens because those drivers are built-in, and are calling
vio_register_driver(). It in turn calls driver_register() with a
reference to vio_bus_type, but we haven't registered vio_bus_type with
the driver core.

Fix it by also guarding vio_register_driver() with a check to see if
we are on pseries.

Fixes: 4336b9337824 ("powerpc/pseries: Make vio and ibmebus initcalls pseries specific")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://lore.kernel.org/r/20210316010938.525657-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/vio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/vio.c b/arch/powerpc/platforms/pseries/vio.c
index b2797cfe4e2b..68276e05502b 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -1286,6 +1286,10 @@ static int vio_bus_remove(struct device *dev)
 int __vio_register_driver(struct vio_driver *viodrv, struct module *owner,
 			  const char *mod_name)
 {
+	// vio_bus_type is only initialised for pseries
+	if (!machine_is(pseries))
+		return -ENODEV;
+
 	pr_debug("%s: driver %s registering\n", __func__, viodrv->name);
 
 	/* fill in 'struct driver' fields */
-- 
2.30.2



