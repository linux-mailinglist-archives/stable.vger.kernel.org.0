Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BE4512A9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347201AbhKOTjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244957AbhKOTSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC71B634F4;
        Mon, 15 Nov 2021 18:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000782;
        bh=y7Z2eJzG6DbsWGb26CCWp+6OetSQo3wGTJPxshlH7Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIf9rz1Z1Iwms7hlXjLrka/hoZixFuCElqJ+a027k3w217M8Px9HddLOOaX03dLyx
         g4dQ8m9QzU/hAAMm7MORFEOj2aXBDvS9ZZt6QJejhw8OSUDe/dtR19/tYClanPXjjQ
         qxpYtJ/6LGW1SteJUrhv5DgZFu8ntAauNqqxnoh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jason Self <jason@bluehome.net>
Subject: [PATCH 5.14 790/849] MIPS: fix duplicated slashes for Platform file path
Date:   Mon, 15 Nov 2021 18:04:33 +0100
Message-Id: <20211115165446.965544395@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
Signed-off-by: Jason Self <jason@bluehome.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -254,7 +254,9 @@ endif
 #
 # Board-dependent options and extra files
 #
+ifdef need-compiler
 include arch/mips/Kbuild.platforms
+endif
 
 ifdef CONFIG_PHYSICAL_START
 load-y					= $(CONFIG_PHYSICAL_START)


