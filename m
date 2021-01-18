Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418A22FA9B2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393791AbhARTIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390527AbhARLjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97EC5223E4;
        Mon, 18 Jan 2021 11:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969915;
        bh=dckCnqTvgGne2hGwAjFkC9CrqtWahdtEUmyBy1AmNQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0F+SbmsWGcQ9G9euIgEKGmOvrkz8W6dkxPJgNf0PRvVRHZcoMkjDLSB5etldpt1E/
         0JexyJTY4btcABVD3Hr3AqwaF8tdYLDIYk4qcsuZz1Ur54gkbVEqgr+cFWdd6jBuIr
         M9OAGuWcZHG8rEQ5bQUbD6D43Pe+s4U4BiQBo1bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Millikin <john@john-millikin.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/76] lib/raid6: Let $(UNROLL) rules work with macOS userland
Date:   Mon, 18 Jan 2021 12:34:36 +0100
Message-Id: <20210118113342.707614360@linuxfoundation.org>
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

From: John Millikin <john@john-millikin.com>

[ Upstream commit 0c36d88cff4d72149f94809303c5180b6f716d39 ]

Older versions of BSD awk are fussy about the order of '-v' and '-f'
flags, and require a space after the flag name. This causes build
failures on platforms with an old awk, such as macOS and NetBSD.

Since GNU awk and modern versions of BSD awk (distributed with
FreeBSD/OpenBSD) are fine with either form, the definition of
'cmd_unroll' can be trivially tweaked to let the lib/raid6 Makefile
work with both old and new awk flag dialects.

Signed-off-by: John Millikin <john@john-millikin.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 0083b5cc646c9..d4d56ca6eafce 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -48,7 +48,7 @@ endif
 endif
 
 quiet_cmd_unroll = UNROLL  $@
-      cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$* < $< > $@
+      cmd_unroll = $(AWK) -v N=$* -f $(srctree)/$(src)/unroll.awk < $< > $@
 
 targets += int1.c int2.c int4.c int8.c int16.c int32.c
 $(obj)/int%.c: $(src)/int.uc $(src)/unroll.awk FORCE
-- 
2.27.0



