Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B813742106F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbhJDNoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238371AbhJDNmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8201163254;
        Mon,  4 Oct 2021 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353564;
        bh=IIGZjhefDL82qZ4bGe8+W6XTlEx8AkPNfd8WgAwNPwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrzV+dLV1lazwndL/LuQWozKc28EtWtBgDYqX3jfz4olDv66amA2AYJoq/2qcO3bU
         A2iHQRgqBiMASsnsvVg3wQfVN96ehicUSmwnyYlyU7nDJvfx0iE8+XdNqkwX3tep2p
         OQe1SLag1HnE3gJV3E+4QOowiSMd4ROgBcO0k1tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.14 171/172] netfilter: nf_tables: Fix oversized kvmalloc() calls
Date:   Mon,  4 Oct 2021 14:53:41 +0200
Message-Id: <20211004125050.500603281@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 45928afe94a094bcda9af858b96673d59bc4a0e9 upstream.

The commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
limits the max allocatable memory via kvmalloc() to MAX_INT.

Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4336,7 +4336,7 @@ static int nf_tables_newset(struct sk_bu
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 	alloc_size = sizeof(*set) + size + udlen;
-	if (alloc_size < size)
+	if (alloc_size < size || alloc_size > INT_MAX)
 		return -ENOMEM;
 	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)


