Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA1F24BEAE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgHTNaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgHTJc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E38820724;
        Thu, 20 Aug 2020 09:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915975;
        bh=7w8lY9SNuQ0ArZc90EjzHkvXIEhkKVW3Y126jgQbW8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJ07W0TL3iHiV/DmU6s6Yu6/+knz3Mq2o8LbHL2LuJ6NkRrhcuioIaGRUNcwC4i1T
         kkJEs7UfQAnEfikB5F+bamZd2/bY3V/LFmziPvlAI1nR1zr6hMIhyWtznl5E6gWyAf
         3P9nEnKa0VqvvTJ2Z7wKfo2CbcmbD1KWOZ2v8lQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 201/232] s390/Kconfig: add missing ZCRYPT dependency to VFIO_AP
Date:   Thu, 20 Aug 2020 11:20:52 +0200
Message-Id: <20200820091622.542844253@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 929a343b858612100cb09443a8aaa20d4a4706d3 ]

The VFIO_AP uses ap_driver_register() (and deregister) functions
implemented in ap_bus.c (compiled into ap.o).  However the ap.o will be
built only if CONFIG_ZCRYPT is selected.

This was not visible before commit e93a1695d7fb ("iommu: Enable compile
testing for some of drivers") because the CONFIG_VFIO_AP depends on
CONFIG_S390_AP_IOMMU which depends on the missing CONFIG_ZCRYPT.  After
adding COMPILE_TEST, it is possible to select a configuration with
VFIO_AP and S390_AP_IOMMU but without the ZCRYPT.

Add proper dependency to the VFIO_AP to fix build errors:

ERROR: modpost: "ap_driver_register" [drivers/s390/crypto/vfio_ap.ko] undefined!
ERROR: modpost: "ap_driver_unregister" [drivers/s390/crypto/vfio_ap.ko] undefined!

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e93a1695d7fb ("iommu: Enable compile testing for some of drivers")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c7d7ede6300c5..4907a5149a8a3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -769,6 +769,7 @@ config VFIO_AP
 	def_tristate n
 	prompt "VFIO support for AP devices"
 	depends on S390_AP_IOMMU && VFIO_MDEV_DEVICE && KVM
+	depends on ZCRYPT
 	help
 		This driver grants access to Adjunct Processor (AP) devices
 		via the VFIO mediated device interface.
-- 
2.25.1



