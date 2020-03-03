Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F34B178066
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732922AbgCCR4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732913AbgCCR4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B1C20728;
        Tue,  3 Mar 2020 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258194;
        bh=MHH9f6Sl1J/Q2oNgbCemXFSvYVS6iwJBMMPs+2grVhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILKth2RM+mUEkFyLomseSLe1kGNwWXGLZ1bE3ir4PRc5yHg1kdPnFG5nPdnTBxOTo
         smzO+20D1/gWQuDGsoUpe1eGcuVwhllUFnmA7VM9v/EQtnLaXFyCFLpgZ2WHAx5URr
         ZCins7hMafzhtw6/uVL4ULJZ5ztjSq7E/Byib3/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH 5.4 090/152] netfilter: ipset: Fix forceadd evaluation path
Date:   Tue,  3 Mar 2020 18:43:08 +0100
Message-Id: <20200303174312.803632057@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

commit 8af1c6fbd9239877998c7f5a591cb2c88d41fb66 upstream.

When the forceadd option is enabled, the hash:* types should find and replace
the first entry in the bucket with the new one if there are no reuseable
(deleted or timed out) entries. However, the position index was just not set
to zero and remained the invalid -1 if there were no reuseable entries.

Reported-by: syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -931,6 +931,8 @@ mtype_add(struct ip_set *set, void *valu
 		}
 	}
 	if (reuse || forceadd) {
+		if (j == -1)
+			j = 0;
 		data = ahash_data(n, j, set->dsize);
 		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS


