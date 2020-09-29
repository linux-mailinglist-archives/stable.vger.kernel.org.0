Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A4727C70A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgI2Luy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgI2LtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B44208B8;
        Tue, 29 Sep 2020 11:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380149;
        bh=7muWTMfFSOoAQDyVIXSONHMtbU5w9R5673QGdkFAnMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEXTKU876ZhHF2hUfpKfjv+p6wxhukf4CfSLZMWrfBQWrXdEEj473/B/rmERkceJc
         HHi5/geTeoJgiMJFNg/FWCG80TakFfR0X7pV1ckSK7A9Vp+V6lKfYkp19o8V5czvc8
         S4ADFNMUKGJFnuq8TNYmLIFmviii2tJ1l6vYtW24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 59/99] SUNRPC: Fix svc_flush_dcache()
Date:   Tue, 29 Sep 2020 13:01:42 +0200
Message-Id: <20200929105932.632481260@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 13a9a9d74d4d9689ad65938966dbc66386063648 ]

On platforms that implement flush_dcache_page(), a large NFS WRITE
triggers the WARN_ONCE in bvec_iter_advance():

Sep 20 14:01:05 klimt.1015granger.net kernel: Attempted to advance past end of bvec iter
Sep 20 14:01:05 klimt.1015granger.net kernel: WARNING: CPU: 0 PID: 1032 at include/linux/bvec.h:101 bvec_iter_advance.isra.0+0xa7/0x158 [sunrpc]

Sep 20 14:01:05 klimt.1015granger.net kernel: Call Trace:
Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_tcp_recvfrom+0x60c/0x12c7 [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? bvec_iter_advance.isra.0+0x158/0x158 [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? del_timer_sync+0x4b/0x55
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27 [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_recv+0x1193/0x15e4 [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? try_to_freeze.isra.0+0x6f/0x6f [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? refcount_sub_and_test.constprop.0+0x13/0x40 [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_xprt_put+0x1e/0x29f [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_send+0x39f/0x3c1 [sunrpc]
Sep 20 14:01:05 klimt.1015granger.net kernel:  nfsd+0x282/0x345 [nfsd]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? __kthread_parkme+0x74/0xba
Sep 20 14:01:05 klimt.1015granger.net kernel:  kthread+0x2ad/0x2bc
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? nfsd_destroy+0x124/0x124 [nfsd]
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27
Sep 20 14:01:05 klimt.1015granger.net kernel:  ? kthread_mod_delayed_work+0x115/0x115
Sep 20 14:01:05 klimt.1015granger.net kernel:  ret_from_fork+0x22/0x30

Reported-by: He Zhe <zhe.he@windriver.com>
Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index c537272f9c7ed..183d2465df7a3 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -228,7 +228,7 @@ static int svc_one_sock_name(struct svc_sock *svsk, char *buf, int remaining)
 static void svc_flush_bvec(const struct bio_vec *bvec, size_t size, size_t seek)
 {
 	struct bvec_iter bi = {
-		.bi_size	= size,
+		.bi_size	= size + seek,
 	};
 	struct bio_vec bv;
 
-- 
2.25.1



