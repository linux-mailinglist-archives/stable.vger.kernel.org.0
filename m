Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D1B171A98
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgB0NzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbgB0NzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 497972469B;
        Thu, 27 Feb 2020 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811709;
        bh=6EtQis6mQeE6kHIL6mvjafifQGOLz1qYtzxe86M3JsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHFt2wluUr3K0O/IjnVgxvjUQKVSUfccHJFVSRjyvLZHrX1WzQrf4Q2OdWRcFauUc
         zRXERts+OO7THd5tPTWObZbh0vKexvqaA+aCxc/tYrUsRVqustEKa9gH7yiL6fb1y2
         VdSdDujvstYG3qqK3Y8gBgTcbmIKwLgM1xs/LxOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/237] kconfig: fix broken dependency in randconfig-generated .config
Date:   Thu, 27 Feb 2020 14:34:43 +0100
Message-Id: <20200227132302.186328629@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit c8fb7d7e48d11520ad24808cfce7afb7b9c9f798 ]

Running randconfig on arm64 using KCONFIG_SEED=0x40C5E904 (e.g. on v5.5)
produces the .config with CONFIG_EFI=y and CONFIG_CPU_BIG_ENDIAN=y,
which does not meet the !CONFIG_CPU_BIG_ENDIAN dependency.

This is because the user choice for CONFIG_CPU_LITTLE_ENDIAN vs
CONFIG_CPU_BIG_ENDIAN is set by randomize_choice_values() after the
value of CONFIG_EFI is calculated.

When this happens, the has_changed flag should be set.

Currently, it takes the result from the last iteration. It should
accumulate all the results of the loop.

Fixes: 3b9a19e08960 ("kconfig: loop as long as we changed some symbols in randconfig")
Reported-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 27aac273205ba..fa423fcd1a928 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1238,7 +1238,7 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
 
 		sym_calc_value(csym);
 		if (mode == def_random)
-			has_changed = randomize_choice_values(csym);
+			has_changed |= randomize_choice_values(csym);
 		else {
 			set_all_choice_values(csym);
 			has_changed = true;
-- 
2.20.1



