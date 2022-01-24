Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583DD4990EE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378520AbiAXUHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:07:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48564 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbiAXTvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:51:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90F336090A;
        Mon, 24 Jan 2022 19:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71283C340E5;
        Mon, 24 Jan 2022 19:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053881;
        bh=EWuSD09ncRWFckeaGe1epERgKjEawSin+XEHc36Lp5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7+c6ARAUg6fbnj0mtSJ9nWqwUYweW7GeW+p0YK9siKKhHYfoPQxmke0ZsO6/KLq1
         biULhaoLoljGfW4QeXzkYrogcEpu0Ot619vCSuHoYgpJvsqQga4HIMYHKF7OwXXuTC
         Cqj3KK3dLuQ9S/fAMUKmvFvgfsuT/5nxnHI42pkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/563] bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().
Date:   Mon, 24 Jan 2022 19:39:31 +0100
Message-Id: <20220124184031.552229798@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit 04c350b1ae6bdb12b84009a4d0bf5ab4e621c47b ]

The commit 4057765f2dee ("sock: consistent handling of extreme
SO_SNDBUF/SO_RCVBUF values") added a change to prevent underflow
in setsockopt() around SO_SNDBUF/SO_RCVBUF.

This patch adds the same change to _bpf_setsockopt().

Fixes: 4057765f2dee ("sock: consistent handling of extreme SO_SNDBUF/SO_RCVBUF values")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220104013153.97906-2-kuniyu@amazon.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index abd58dce49bbc..706c31ae65b01 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4711,12 +4711,14 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		switch (optname) {
 		case SO_RCVBUF:
 			val = min_t(u32, val, sysctl_rmem_max);
+			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 			WRITE_ONCE(sk->sk_rcvbuf,
 				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 			break;
 		case SO_SNDBUF:
 			val = min_t(u32, val, sysctl_wmem_max);
+			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 			WRITE_ONCE(sk->sk_sndbuf,
 				   max_t(int, val * 2, SOCK_MIN_SNDBUF));
-- 
2.34.1



