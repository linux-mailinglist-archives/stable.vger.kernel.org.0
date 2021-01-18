Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09392FA9A2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405528AbhARTBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390562AbhARLkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7BE3223E4;
        Mon, 18 Jan 2021 11:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969967;
        bh=tT2JVAOyu67caF+7hVecNlQnhoOZBnX1WTz/U0A/ivw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScpQH3ErVLnOfFlBbWq2ahbqBwYOnaDOC4gYe8aBTzleh9U/k4Atu55GpKUhUdcuU
         qKdgxcIQF6CQhe/zvmKWe4pmX+kn8E4lDDUM4H5fdAu1bgSYEZmsogntdvpJ5NB2DI
         ru3BAZKjcP6dQbt6NTnwElgrf4igilDggBbtdlUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/76] ARC: build: add uImage.lzma to the top-level target
Date:   Mon, 18 Jan 2021 12:34:26 +0100
Message-Id: <20210118113342.241816060@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f2712ec76a5433e5ec9def2bd52a95df1f96d050 ]

arch/arc/boot/Makefile supports uImage.lzma, but you cannot do
'make uImage.lzma' because the corresponding target is missing
in arch/arc/Makefile. Add it.

I also changed the assignment operator '+=' to ':=' since this is the
only place where we expect this variable to be set.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 5e5699acefef4..b0b119ebd9e9f 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -90,7 +90,7 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-boot_targets += uImage uImage.bin uImage.gz
+boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
-- 
2.27.0



