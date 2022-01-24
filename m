Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B844997ED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449933AbiAXVRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448674AbiAXVNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B4BEB8122A;
        Mon, 24 Jan 2022 21:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9090DC340E5;
        Mon, 24 Jan 2022 21:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058813;
        bh=F2oYiKHVZmI6LKK4R/SUjdr8SVXHmnrD7tlG1U1IfVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSwfMPPMwYnSOxt0Qv6WsF8bFEgg3SkayQla1lVFSSg33DvoBtLANXmh9Di8iK4xQ
         KvOIBg9BC1DPVJt4AYx//8ueu/hDN4su7kiVNsObBoWGP3CIaVNmpyTCpHBgl/4XQn
         6lIExVLWflMGiGrBghxb1rkV1tADuyjYEjdaOdnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0377/1039] bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().
Date:   Mon, 24 Jan 2022 19:36:06 +0100
Message-Id: <20220124184137.979604025@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 6102f093d59a5..31147a4cfab30 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4742,12 +4742,14 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
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



