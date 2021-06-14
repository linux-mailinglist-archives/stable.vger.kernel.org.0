Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9563A63F4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhFNLSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235554AbhFNLQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E704061979;
        Mon, 14 Jun 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667807;
        bh=NTfLOom7dZ4p9kTBXVZj/H0yZeFWVs30lQS5BXTI0WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PC69FNLc0MatFayz0H+t0wJJszw14wbqEE5KZP0ch1Wv3RM3ckKlC9GffqvJ6GKbC
         11KsJONehzQ3HNRmv5Inv2WhP1y/g0FjSX/7fMk9A6jP3GX6yglj/LUDfI2EeqLlqB
         P6CuT2YS/xCsQnNjuWhAsRq9XHrUl011Nenrnveg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.12 082/173] tools/bootconfig: Fix a build error accroding to undefined fallthrough
Date:   Mon, 14 Jun 2021 12:26:54 +0200
Message-Id: <20210614102700.886001786@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 824afd55e95c3cb12c55d297a0ae408be1779cc8 upstream.

Since the "fallthrough" is defined only in the kernel, building
lib/bootconfig.c as a part of user-space tools causes a build
error.

Add a dummy fallthrough to avoid the build error.

Link: https://lkml.kernel.org/r/162087519356.442660.11385099982318160180.stgit@devnote2

Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 4c1ca831adb1 ("Revert "lib: Revert use of fallthrough pseudo-keyword in lib/"")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/include/linux/bootconfig.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bootconfig/include/linux/bootconfig.h b/tools/bootconfig/include/linux/bootconfig.h
index 078cbd2ba651..de7f30f99af3 100644
--- a/tools/bootconfig/include/linux/bootconfig.h
+++ b/tools/bootconfig/include/linux/bootconfig.h
@@ -4,4 +4,8 @@
 
 #include "../../../../include/linux/bootconfig.h"
 
+#ifndef fallthrough
+# define fallthrough
+#endif
+
 #endif
-- 
2.32.0



