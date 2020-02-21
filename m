Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBE1670B8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgBUHrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgBUHrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:47:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 413A3222C4;
        Fri, 21 Feb 2020 07:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271260;
        bh=j10t5HO3W2ltOm3+De7grvLgQUA7DCKNukRC3XW6FKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIoavv12lfHqrk/Kvtp1brFnhfrzDWtv6uUK+cEmkz8/PClvkPxY8cCU1a4l5E6fz
         imIPGeyyOqR/wH0mHed7JNo8n2u3Lus2bMB+G47hMzWjAd2lxA2IdDw+9JR34OLKWG
         P/+zssTfKciwQhnJYogU1UpuSju3u0gAX/teaIRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 099/399] kconfig: fix broken dependency in randconfig-generated .config
Date:   Fri, 21 Feb 2020 08:37:04 +0100
Message-Id: <20200221072412.031746752@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
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
index 3569d2dec37ce..17298239e3633 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1353,7 +1353,7 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
 
 		sym_calc_value(csym);
 		if (mode == def_random)
-			has_changed = randomize_choice_values(csym);
+			has_changed |= randomize_choice_values(csym);
 		else {
 			set_all_choice_values(csym);
 			has_changed = true;
-- 
2.20.1



