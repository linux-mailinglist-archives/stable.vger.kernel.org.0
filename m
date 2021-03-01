Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCF032895C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbhCARzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:55:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238617AbhCARth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DC6F650EC;
        Mon,  1 Mar 2021 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618007;
        bh=Bko+Wm0UuPJLzh4azU5u9LN+7ZRjmySD0dUobLg2ZjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRzKGde7nRpQg4cNGOQrEsG5ts+ERMf/MiPcbJiYl0NETpL60dNI+L+1honzHgO7d
         KgK3oNREaMOu2VV9rie6wyxjCO4HHkfuUE/OHG75X30LzOxkhSskCL8N/tpSOosA/5
         y3Xp41PzoGS/MY123pEwJqGFv7qLwa5Uv+jgGa00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 275/340] seccomp: Add missing return in non-void function
Date:   Mon,  1 Mar 2021 17:13:39 +0100
Message-Id: <20210301161101.822429256@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 04b38d012556199ba4c31195940160e0c44c64f0 upstream.

We don't actually care about the value, since the kernel will panic
before that; but a value should nonetheless be returned, otherwise the
compiler will complain.

Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
Cc: stable@vger.kernel.org # 4.7+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210111172839.640914-1-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -921,6 +921,8 @@ static int __seccomp_filter(int this_sys
 			    const bool recheck_after_trace)
 {
 	BUG();
+
+	return -1;
 }
 #endif
 


