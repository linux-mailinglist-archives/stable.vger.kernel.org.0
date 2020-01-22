Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D9145583
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgAVNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729425AbgAVNWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:41 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D49B2468C;
        Wed, 22 Jan 2020 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699361;
        bh=G5oThlaiHggG4BtupsoslD6PHZ8zb7l3LumKJofs4bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMMI4rMmH2whEprWlpMW8Bjl8daeuIsK1XeFUcrhK9tTa7damSrHTjl0GThrn/r+e
         qkbq3cXgatMnPkg51e6AnjAYx091xRmwrb3FUZO/KdKmQxCi2Bgo/VO1nF6cqWQ9rz
         cVtLF/j/TlTJqEEBGi4aNZ//cJFRT4QKoEjmV/X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 121/222] cfg80211: fix page refcount issue in A-MSDU decap
Date:   Wed, 22 Jan 2020 10:28:27 +0100
Message-Id: <20200122092842.401964700@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 81c044fc3bdc5b7be967cd3682528ea94b58c06a upstream.

The fragments attached to a skb can be part of a compound page. In that case,
page_ref_inc will increment the refcount for the wrong page. Fix this by
using get_page instead, which calls page_ref_inc on the compound head and
also checks for overflow.

Fixes: 2b67f944f88c ("cfg80211: reuse existing page fragments in A-MSDU rx")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200113182107.20461-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -564,7 +564,7 @@ __frame_add_frag(struct sk_buff *skb, st
 	struct skb_shared_info *sh = skb_shinfo(skb);
 	int page_offset;
 
-	page_ref_inc(page);
+	get_page(page);
 	page_offset = ptr - page_address(page);
 	skb_add_rx_frag(skb, sh->nr_frags, page, page_offset, len, size);
 }


