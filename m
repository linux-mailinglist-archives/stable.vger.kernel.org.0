Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0D337CDA7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238634AbhELQ5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244041AbhELQm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E2861D2D;
        Wed, 12 May 2021 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835785;
        bh=tVvGiNUqAvkRxYGTGRw6g01OdGUEfPQHRJNlvPVry/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITfZS7J+QPkg5AKXzGRGIWd5ICTPxvDKi7TScp6ubwJDFNDsCC+g+mX3P/RMnjFMd
         nFciUlKKLb6fdw4BpvEglbjLo++LnvdtpdqRNfsPgmSOjYTPc7tHqABwwa9j9yYXN3
         PKVoqObJImS9kiwpIswn110SEA+w59CtRIEoBJfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 483/677] powerpc/pseries: Only register vio drivers if vio bus exists
Date:   Wed, 12 May 2021 16:48:49 +0200
Message-Id: <20210512144853.410132128@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 9cb4fc839fd5..429053d0402a 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -1285,6 +1285,10 @@ static int vio_bus_remove(struct device *dev)
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



