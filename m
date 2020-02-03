Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC7E150CC7
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgBCQjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731376AbgBCQho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:44 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39F492051A;
        Mon,  3 Feb 2020 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747863;
        bh=TRgddOces3KCcjZiCU9InaohUeoG1Yx/UpbqoCBwJ7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCc8bg6NATVpbE6hnhhK51dUU7nQEl9/7Rr2aoGay/Nn8yhXuaprYNW2zodpeXDZc
         ITSd2rurznucJQF7EtvyAl3ondeMJE1MtthqjnsgbUgq80uDSArcVDffmjJvesO1oy
         pYYV1gJIjFPW7OD7Gfcx+jRTUt1evRb6mJDINc7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.5 12/23] arm64: kbuild: remove compressed images on make ARCH=arm64 (dist)clean
Date:   Mon,  3 Feb 2020 16:20:32 +0000
Message-Id: <20200203161905.006724061@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.288335885@linuxfoundation.org>
References: <20200203161902.288335885@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

commit d7bbd6c1b01cb5dd13c245d4586a83145c1d5f52 upstream.

Since v4.3-rc1 commit 0723c05fb75e44 ("arm64: enable more compressed
Image formats"), it is possible to build Image.{bz2,lz4,lzma,lzo}
AArch64 images. However, the commit missed adding support for removing
those images on 'make ARCH=arm64 (dist)clean'.

Fix this by adding them to the target list.
Make sure to match the order of the recipes in the makefile.

Cc: stable@vger.kernel.org # v4.3+
Fixes: 0723c05fb75e44 ("arm64: enable more compressed Image formats")
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/Makefile
+++ b/arch/arm64/boot/Makefile
@@ -16,7 +16,7 @@
 
 OBJCOPYFLAGS_Image :=-O binary -R .note -R .note.gnu.build-id -R .comment -S
 
-targets := Image Image.gz
+targets := Image Image.bz2 Image.gz Image.lz4 Image.lzma Image.lzo
 
 $(obj)/Image: vmlinux FORCE
 	$(call if_changed,objcopy)


