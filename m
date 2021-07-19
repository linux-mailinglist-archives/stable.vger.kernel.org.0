Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AAD3CDDA2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245748AbhGSO7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245319AbhGSO6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1F746023D;
        Mon, 19 Jul 2021 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708953;
        bh=SQN+3Kulvivgnq/wgeiUCuPyJFYyEXXhyjhCJeuXMio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKne27s7zJSgVxdMsaIacx8rftdC8plecNsXrgF35+HWF7eb3afjIBH41vXTGsHhQ
         ZLZmh3UtekkH3P6zDvCKGW5B5w0+FRa1oJGsnYmt4HyDdVfdUxafXQzaYRvpl1PV7+
         puvtcudb2Kn8Dql0fRBaRzP8oEu4+HPxEy2kenRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 196/421] s390: appldata depends on PROC_SYSCTL
Date:   Mon, 19 Jul 2021 16:50:07 +0200
Message-Id: <20210719144953.187732532@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5d3516b3647621d5a1180672ea9e0817fb718ada ]

APPLDATA_BASE should depend on PROC_SYSCTL instead of PROC_FS.
Building with PROC_FS but not PROC_SYSCTL causes a build error,
since appldata_base.c uses data and APIs from fs/proc/proc_sysctl.c.

arch/s390/appldata/appldata_base.o: in function `appldata_generic_handler':
appldata_base.c:(.text+0x192): undefined reference to `sysctl_vals'

Fixes: c185b783b099 ("[S390] Remove config options.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20210528002420.17634-1-rdunlap@infradead.org
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9a9c7a6fe925..ce4c3b659f70 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -867,7 +867,7 @@ config CMM_IUCV
 config APPLDATA_BASE
 	def_bool n
 	prompt "Linux - VM Monitor Stream, base infrastructure"
-	depends on PROC_FS
+	depends on PROC_SYSCTL
 	help
 	  This provides a kernel interface for creating and updating z/VM APPLDATA
 	  monitor records. The monitor records are updated at certain time
-- 
2.30.2



