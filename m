Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA9420C94
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhJDNHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234564AbhJDNF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3E561A03;
        Mon,  4 Oct 2021 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352450;
        bh=kecqeoEY1ApU2mMIuYtqh1Ysyhtgb9SGG7Gj0G8KGCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiRTPM5Yosefbzm83v/TMBZJS4t2gOF/EYS+3sc6C0kamZy7k53gEduEwnThBFhAF
         HqwR+38toXCfZg1FTNAVEfU0M5Pu/MjXcfoABYTyOzz1qR1oQtb6wT8Midn/7+O0Hm
         DTwDt/RXoD5BSxnpGLbhxaVTsHl3/jResHym95PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.14 66/75] ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE
Date:   Mon,  4 Oct 2021 14:52:41 +0200
Message-Id: <20211004125033.754662860@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 6fa630bf473827aee48cbf0efbbdf6f03134e890 upstream

FTRACE_ADDR is only defined when CONFIG_DYNAMIC_FTRACE is defined, the
latter is even stronger requirement than CONFIG_FUNCTION_TRACER (which is
enough for MCOUNT_ADDR).

Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZUVCQBHDMFVR7CCB7JPESLJEWERZDJ3T/

Fixes: 1f12fb25c5c5d22f ("ARM: 9079/1: ftrace: Add MODULE_PLTS support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/module-plts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -24,7 +24,7 @@
 #endif
 
 static const u32 fixed_plts[] = {
-#ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_DYNAMIC_FTRACE
 	FTRACE_ADDR,
 	MCOUNT_ADDR,
 #endif


