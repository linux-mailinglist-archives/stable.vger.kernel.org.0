Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DC63ED5D5
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhHPNP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237520AbhHPNNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A19E632C0;
        Mon, 16 Aug 2021 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119447;
        bh=tJRxt6R0nDizbvrBIJUeMhQ+idTbHvZENKG3Jn2g5G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KziZRwrFW3eEOtKjOYJnrBBJg9MMe0eEMprehROo7B7OFNSEkXJGWxEFBeExEdXFa
         slEiBraYFoIUBpJTw39xbgbKZUOe27jCJLFcQg5+84n1o1xWpjNTCHnKo3ICEgLew8
         D6bi1WA6eufzfwgiv/i34633uh2WTtxXmnT6yYdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsuan-Chi Kuo <hsuanchikuo@gmail.com>,
        Wiktor Garbacz <wiktorg@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.13 022/151] seccomp: Fix setting loaded filter count during TSYNC
Date:   Mon, 16 Aug 2021 15:00:52 +0200
Message-Id: <20210816125444.801772013@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsuan-Chi Kuo <hsuanchikuo@gmail.com>

commit b4d8a58f8dcfcc890f296696cadb76e77be44b5f upstream.

The desired behavior is to set the caller's filter count to thread's.
This value is reported via /proc, so this fixes the inaccurate count
exposed to userspace; it is not used for reference counting, etc.

Signed-off-by: Hsuan-Chi Kuo <hsuanchikuo@gmail.com>
Link: https://lore.kernel.org/r/20210304233708.420597-1-hsuanchikuo@gmail.com
Co-developed-by: Wiktor Garbacz <wiktorg@google.com>
Signed-off-by: Wiktor Garbacz <wiktorg@google.com>
Link: https://lore.kernel.org/lkml/20210810125158.329849-1-wiktorg@google.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Fixes: c818c03b661c ("seccomp: Report number of loaded filters in /proc/$pid/status")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -602,7 +602,7 @@ static inline void seccomp_sync_threads(
 		smp_store_release(&thread->seccomp.filter,
 				  caller->seccomp.filter);
 		atomic_set(&thread->seccomp.filter_count,
-			   atomic_read(&thread->seccomp.filter_count));
+			   atomic_read(&caller->seccomp.filter_count));
 
 		/*
 		 * Don't let an unprivileged task work around


