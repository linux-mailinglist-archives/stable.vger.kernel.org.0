Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE07733B5C2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhCONzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229735AbhCONyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9389E64F01;
        Mon, 15 Mar 2021 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816486;
        bh=R1pNyKCM/PBIzuBoRjcqRWbmjKQHZqUQBiBoXuUa49A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxHv+EEZhQUFrAGhjHIJxebKfE0wOW4EBwOxNrQ1LAm5HiVyzsibFlLeoHaLpdo9c
         ldkSTdwkw/Qbn8wzLUrfL2Bzy9QiDRu79GqhUIR6arIWWm6jIQAoWIjb0tOllaMUHF
         3AZCxVlQKuZc/AAzSsU19Z6hS6YDYgOpyqeRmG8E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 67/78] alpha: make short build log available for division routines
Date:   Mon, 15 Mar 2021 14:52:30 +0100
Message-Id: <20210315135214.263613594@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 3eec0291830e4c28d09f73bab247f3b59172022b upstream.

This enables the Kbuild standard log style as follows:

  AS      arch/alpha/lib/__divlu.o
  AS      arch/alpha/lib/__divqu.o
  AS      arch/alpha/lib/__remlu.o
  AS      arch/alpha/lib/__remqu.o

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/lib/Makefile
+++ b/arch/alpha/lib/Makefile
@@ -47,5 +47,5 @@ AFLAGS___divlu.o = -DDIV       -DINTSIZE
 AFLAGS___remlu.o =       -DREM -DINTSIZE
 
 $(addprefix $(obj)/,__divqu.o __remqu.o __divlu.o __remlu.o): \
-							$(src)/$(ev6-y)divide.S
-	$(cmd_as_o_S)
+						$(src)/$(ev6-y)divide.S FORCE
+	$(call if_changed_rule,as_o_S)


