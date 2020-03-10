Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391C817FE26
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgCJMsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbgCJMsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB13920674;
        Tue, 10 Mar 2020 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844485;
        bh=E7HA8Tb6z/fR4TEQUjmrtS8FF/XCbRmKlwiBpuiJBeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CP3fb0N5unX1QFWmLw6OOj+M6Ru6qbL/Jj3Ur056pdSnmp5Zsz1Mq8XfeXbF+hUu+
         qYR2zFyGp83kjdC7QDE+NnZlFeydC/md92j329gF/o3LRY07tbkyg+hHP0Uxb+AJ67
         M2B+xmcug0HyqQwaowKirRKzMVl/iwYy9o1Mvze4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/168] kbuild: fix No such file or directory warning when cleaning
Date:   Tue, 10 Mar 2020 13:37:36 +0100
Message-Id: <20200310123636.818007750@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit cf6b58ab2d55f5a143c88c219c8e66ff0720fa69 ]

Since commit fcbb8461fd23 ("kbuild: remove header compile test"),
'make clean' with O= option in the pristine source tree emits
'No such file or directory' warning.

$ git clean -d -f -x
$ make O=foo clean
make[1]: Entering directory '/home/masahiro/linux/foo'
find: ‘usr/include’: No such file or directory
make[1]: Leaving directory '/home/masahiro/linux/foo'

Fixes: fcbb8461fd23 ("kbuild: remove header compile test")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/include/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/include/Makefile b/usr/include/Makefile
index 47cb91d3a51d2..e2840579156a9 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -99,7 +99,7 @@ endif
 # asm-generic/*.h is used by asm/*.h, and should not be included directly
 header-test- += asm-generic/%
 
-extra-y := $(patsubst $(obj)/%.h,%.hdrtest, $(shell find $(obj) -name '*.h'))
+extra-y := $(patsubst $(obj)/%.h,%.hdrtest, $(shell find $(obj) -name '*.h' 2>/dev/null))
 
 quiet_cmd_hdrtest = HDRTEST $<
       cmd_hdrtest = \
-- 
2.20.1



