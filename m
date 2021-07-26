Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25D3D61CA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhGZPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhGZPav (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CAA160C41;
        Mon, 26 Jul 2021 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315878;
        bh=yu7KDNuu4XiyOkYsOwCOvWXtvwsAYvHpCvx5r92EoWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXcBgNOip9xythpFlLzV6tVAKw87m0UsmPNMAq6WEoxq1vJMM2+znX3KsTQWrROqt
         TW+j5rhGVcNmIy5IIFn/eQSxrvk0PkwNJa9Odu8ZQGaT5ac/QRDAmQqO+5nz/HLwrQ
         VzwAa2HpuWIudtJ5fYHk4732OIXgzxNEDbUnrniQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 101/223] ACPI: Kconfig: Fix table override from built-in initrd
Date:   Mon, 26 Jul 2021 17:38:13 +0200
Message-Id: <20210726153849.578170105@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@amd.com>

[ Upstream commit d2cbbf1fe503c07e466c62f83aa1926d74d15821 ]

During a rework of initramfs code the INITRAMFS_COMPRESSION config
option was removed in commit 65e00e04e5ae. A leftover as a dependency
broke the config option ACPI_TABLE_OVERRIDE_VIA_ BUILTIN_INITRD that
is used to enable the overriding of ACPI tables from built-in initrd.
Fixing the dependency.

Fixes: 65e00e04e5ae ("initramfs: refactor the initramfs build rules")
Signed-off-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index eedec61e3476..226f849fe7dc 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -370,7 +370,7 @@ config ACPI_TABLE_UPGRADE
 config ACPI_TABLE_OVERRIDE_VIA_BUILTIN_INITRD
 	bool "Override ACPI tables from built-in initrd"
 	depends on ACPI_TABLE_UPGRADE
-	depends on INITRAMFS_SOURCE!="" && INITRAMFS_COMPRESSION=""
+	depends on INITRAMFS_SOURCE!="" && INITRAMFS_COMPRESSION_NONE
 	help
 	  This option provides functionality to override arbitrary ACPI tables
 	  from built-in uncompressed initrd.
-- 
2.30.2



