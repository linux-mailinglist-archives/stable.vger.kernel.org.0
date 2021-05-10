Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF673788B4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhEJLXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237186AbhEJLLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B9F861878;
        Mon, 10 May 2021 11:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644874;
        bh=NFNyn395/FhS4xHrSmlek6QktLX55yar9YDy+li1T5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFVMzM+uCpzsCcEgEMclRGOAJsI58i7dnqfvM5KX0hBt/C0uiKld/hLfAbfZRZL0R
         3RpUP8pemZqO41ZAUNJPhAfQqrIB3OOynWdzft4O2vwQA01Ul5UY848npIh44fhcB+
         hJUQQMWvJ87D01cwREKPG6KaCtOprSO4uE1LgvIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>,
        Tom Rix <trix@redhat.com>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 258/384] mfd: intel-m10-bmc: Fix the register access range
Date:   Mon, 10 May 2021 12:20:47 +0200
Message-Id: <20210510102023.376470534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

[ Upstream commit d9b326b2c3673f939941806146aee38e5c635fd0 ]

This patch fixes the max register address of MAX 10 BMC. The range
0x20000000 ~ 0x200000fc are for control registers of the QSPI flash
controller, which are not accessible to host.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/intel-m10-bmc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/intel-m10-bmc.h b/include/linux/mfd/intel-m10-bmc.h
index 74d4e193966a..9b54ca13eac3 100644
--- a/include/linux/mfd/intel-m10-bmc.h
+++ b/include/linux/mfd/intel-m10-bmc.h
@@ -11,7 +11,7 @@
 
 #define M10BMC_LEGACY_SYS_BASE		0x300400
 #define M10BMC_SYS_BASE			0x300800
-#define M10BMC_MEM_END			0x200000fc
+#define M10BMC_MEM_END			0x1fffffff
 
 /* Register offset of system registers */
 #define NIOS2_FW_VERSION		0x0
-- 
2.30.2



