Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973701B41A4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgDVKID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:32962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgDVKIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:08:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7BC2077D;
        Wed, 22 Apr 2020 10:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550081;
        bh=W5iQkxgtxVfawB7TEp41JwyAqy+uC8RmFSlbEstYjkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REgUMFKLtQ4FG65y3rRN7bv0sN3/7sHmMKnGNmoxXezubXbwJFNJUWzqRlWNrz0JP
         fAd0pIV3ZGEblsyds6LohCjCH347f0vqG8xCRZTTDXJ/ZcVSvA5Peh3QfIcwmg/rHl
         QHAQt6SxjlQxonFnG/0mdc3+Mcr/ij/8zkfD+iTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.9 101/125] arm64: cpu_errata: include required headers
Date:   Wed, 22 Apr 2020 11:56:58 +0200
Message-Id: <20200422095049.344784619@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 94a5d8790e79ab78f499d2d9f1ff2cab63849d9f upstream.

Without including psci.h and arm-smccc.h, we now get a build failure in
some configurations:

arch/arm64/kernel/cpu_errata.c: In function 'arm64_update_smccc_conduit':
arch/arm64/kernel/cpu_errata.c:278:10: error: 'psci_ops' undeclared (first use in this function); did you mean 'sysfs_ops'?

arch/arm64/kernel/cpu_errata.c: In function 'arm64_set_ssbd_mitigation':
arch/arm64/kernel/cpu_errata.c:311:3: error: implicit declaration of function 'arm_smccc_1_1_hvc' [-Werror=implicit-function-declaration]
   arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpu_errata.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -16,6 +16,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm-smccc.h>
+#include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/cachetype.h>
 #include <asm/cpu.h>


