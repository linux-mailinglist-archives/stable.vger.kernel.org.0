Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F90A8FDB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389046AbfIDSGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389401AbfIDSGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5496B23402;
        Wed,  4 Sep 2019 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620371;
        bh=wi7QPloT7ZupYfLWvxNTgmmg5zP7Awd/iBAz68mCT38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXXNZjEdA1dQd7WerCZ0YDqc0eqbzINJhinTzUjRe7mcZsPJOpL1DLTHSMCbmrGi6
         H9drH/Wd6KQbxkNu6FDGjh6YjjHjW005ObBs9WZz5GW46DMcJy5hKlkv+FgnC6UGBo
         oSJo2yyRNeq7XSsEgzh/bIgDLFerGtuo4LY5YxmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 32/93] net/tls: swap sk_write_space on close
Date:   Wed,  4 Sep 2019 19:53:34 +0200
Message-Id: <20190904175306.030325372@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 57c722e932cfb82e9820bbaae1b1f7222ea97b52 ]

Now that we swap the original proto and clear the ULP pointer
on close we have to make sure no callback will try to access
the freed state. sk_write_space is not part of sk_prot, remember
to swap it.

Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -301,6 +301,7 @@ static void tls_sk_proto_close(struct so
 #else
 	{
 #endif
+		sk->sk_write_space = ctx->sk_write_space;
 		tls_ctx_free(ctx);
 		ctx = NULL;
 	}


