Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B273177F53
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbgCCRuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731208AbgCCRuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99C7220870;
        Tue,  3 Mar 2020 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257802;
        bh=MHH9f6Sl1J/Q2oNgbCemXFSvYVS6iwJBMMPs+2grVhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jr8zAl9K3kPLhR6aj4EEUNr7+S6P7697z8B5r1KiFTrcrdMJ17RbdKXX6kFktjD81
         dkLE5q98Ev0ZwxFf1/MGs2PDfH0F7+ei4Apys1Yovdf96YAxQc/6m7zSIOXNyXUdRs
         6DXnAn+LqUHYWiAtdQcCXLsnJ7BfpyW+6ucskIq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH 5.5 105/176] netfilter: ipset: Fix forceadd evaluation path
Date:   Tue,  3 Mar 2020 18:42:49 +0100
Message-Id: <20200303174316.991143238@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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


