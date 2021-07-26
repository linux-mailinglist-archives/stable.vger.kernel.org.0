Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEB13D6082
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhGZPWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237395AbhGZPWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C7F360EB2;
        Mon, 26 Jul 2021 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315390;
        bh=6zjvGesrqqih2bmgSj78nVec1w2WkC82+VvLKUOBEw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtPW9CkMJ7PKG1vY8n2bIwH1UT+fFp/k3NkMXPCw4Bw4nHiGskFDg4RuzHpJQ+wu/
         KKXYrzZS0L0smIaiHPmPwGW8eErLzjq7l44aSso4SP+1wkwA8Jvsjn5nsQ+Am5Ztgj
         mxxu1mHgo0qCW732See2xKXKJIxIcrHQtgiFsSe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/167] ACPI: Kconfig: Fix table override from built-in initrd
Date:   Mon, 26 Jul 2021 17:38:31 +0200
Message-Id: <20210726153842.024682725@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index edf1558c1105..b5ea34c340cc 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -359,7 +359,7 @@ config ACPI_TABLE_UPGRADE
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



