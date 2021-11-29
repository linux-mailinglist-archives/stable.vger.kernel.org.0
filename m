Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC43A461E43
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbhK2Se5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:34:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50332 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379172AbhK2Scz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:32:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5055CE13D5;
        Mon, 29 Nov 2021 18:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52303C53FC7;
        Mon, 29 Nov 2021 18:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210574;
        bh=JJSuTk4A1PpcEuu+ybM8UTi0kRjw23BwUUoPsOM4Or8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLt4HOG1fLMloNST/VhMv6dxlHvZAVXZFAXK1dyEje8S64cEL0z9NfIT2puYZSqvR
         ZZyFqJp//Dk8YifJ/eOvDdFYlleUb2a2enUCwUEqe4QVzyVgLYQ8AWNQY/8DvQll31
         IY+imYj7rORMFrARGonOI9eu3i6HyRGdlESwNdKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/121] netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY
Date:   Mon, 29 Nov 2021 19:17:52 +0100
Message-Id: <20211129181713.033100638@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

[ Upstream commit ad81d4daf6a3f4769a346e635d5e1e967ca455d9 ]

filter->orig_flags was used for a reply context.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index cb4cfa4f61a8d..39e0ff41688a7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -973,7 +973,7 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   CTA_TUPLE_REPLY,
 						   filter->family,
 						   &filter->zone,
-						   filter->orig_flags);
+						   filter->reply_flags);
 		if (err < 0) {
 			err = -EINVAL;
 			goto err_filter;
-- 
2.33.0



