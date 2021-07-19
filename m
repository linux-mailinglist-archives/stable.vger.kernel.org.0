Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2445B3CD7CF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242261AbhGSOTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241449AbhGSOSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEDE6113C;
        Mon, 19 Jul 2021 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706755;
        bh=0BY0t4Fzco4r9Lcj0qjm7oed1hpxVchJqiMpRyJiHt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7TdZPYalY2S3qgMx17VGOjNQay6aVhDNJDzD5vnC1WHXC1+TqCxDmm9dh0zdlYNt
         9VhSxRVBV3YSABXNjD3XSbdUMo+jahrCH9pamG3j+8+9ofiWcdZLfSceKOKiv1v5B6
         KYp4KkUDEMPM4BED5jsLmW4ttSegp0mJx2ZdkPoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 085/188] s390: appldata depends on PROC_SYSCTL
Date:   Mon, 19 Jul 2021 16:51:09 +0200
Message-Id: <20210719144932.849873918@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 9bdaeb38a768..7466e034e1fc 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -834,7 +834,7 @@ config CMM_IUCV
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



