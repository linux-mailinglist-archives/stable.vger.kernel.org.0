Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6923284CF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhCAQnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhCAQgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:36:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA9AD64F68;
        Mon,  1 Mar 2021 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616001;
        bh=X13sxrpqxs9gzSKNhnR5g0N8S67Yn/PtsvZWft5myFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnJg65tapEPiXxxVeJliHRN4j+ZcU32Td1ZkNfW1SdZdPlYbDZinATE0GVWl1qY6v
         GmtSHpaZ0BQPMUfxtG+Yr01aLQeepMVlaIIw7dkzb+2wEOjt1w9k7DHG22L0lQqgi/
         mddixN6rXQ7nDNT9MClhu/sHC+r0/P/3k3U86KlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.9 105/134] seccomp: Add missing return in non-void function
Date:   Mon,  1 Mar 2021 17:13:26 +0100
Message-Id: <20210301161018.730189908@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
@@ -669,6 +669,8 @@ static int __seccomp_filter(int this_sys
 			    const bool recheck_after_trace)
 {
 	BUG();
+
+	return -1;
 }
 #endif
 


