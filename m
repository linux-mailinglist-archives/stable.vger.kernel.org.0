Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D335451E81
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348409AbhKPAgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344990AbhKOTZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C79A632AB;
        Mon, 15 Nov 2021 19:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003298;
        bh=LYBVNB9Y9JyRrt/+XWa7RebFNSVPX+c5sdLVwJoSjuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/jhGewv/eSZ8ttGc1K1yP5u9moPV/qtkqe7qDhM+GsH9Cj8ygI+Lq+y//1O1jniF
         /cu54/7B8Knf9pD4ipt8T47kv3SzmH1tFlIX3BrWKPPLyz7PvEUxSaZEaNVtv6kNec
         r7P3CXZ0eDq4fmOuFdcegj9Zv9wQ7NNQUWMLmrjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jason Self <jason@bluehome.net>
Subject: [PATCH 5.15 851/917] MIPS: fix duplicated slashes for Platform file path
Date:   Mon, 15 Nov 2021 18:05:46 +0100
Message-Id: <20211115165457.888840778@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit cca2aac8acf470b01066f559acd7146fc4c32ae8 upstream.

platform-y accumulates platform names with a slash appended.
The current $(patsubst ...) ends up with doubling slashes.

GNU Make still include Platform files, but in case of an error,
a clumsy file path is displayed:

  arch/mips/loongson2ef//Platform:36: *** only binutils >= 2.20.2 have needed option -mfix-loongson2f-nop.  Stop.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jason Self <jason@bluehome.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Kbuild.platforms |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Kbuild.platforms
+++ b/arch/mips/Kbuild.platforms
@@ -38,4 +38,4 @@ platform-$(CONFIG_MACH_TX49XX)		+= txx9/
 platform-$(CONFIG_MACH_VR41XX)		+= vr41xx/
 
 # include the platform specific files
-include $(patsubst %, $(srctree)/arch/mips/%/Platform, $(platform-y))
+include $(patsubst %/, $(srctree)/arch/mips/%/Platform, $(platform-y))


