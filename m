Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC0B36ADFB
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhDZHkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233306AbhDZHjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5FF7613AF;
        Mon, 26 Apr 2021 07:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422622;
        bh=eN5I8K7RBY3EJw7ZFuCloF79mDp+Hww8Bs79rFNs6Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuZKEEeYGrCZQEFuARqnadq+YUOPt4PJVx+T0gwLkpFgYGSKkbJsUDUrCS5OaGKBX
         OtoDd0dqrMNjaVjaQNWvXaKsqhyDIPe+M5uUlwznzK5CkidVv4s1Y2vUbuEwJQjc3z
         Gap7X5V0T07G10LX4J2T3phXRanPN+HDpSt5LRSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 31/57] netfilter: conntrack: do not print icmpv6 as unknown via /proc
Date:   Mon, 26 Apr 2021 09:29:28 +0200
Message-Id: <20210426072821.640388471@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit fbea31808ca124dd73ff6bb1e67c9af4607c3e32 upstream.

/proc/net/nf_conntrack shows icmpv6 as unknown.

Fixes: 09ec82f5af99 ("netfilter: conntrack: remove protocol name from l4proto struct")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_standalone.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -262,6 +262,7 @@ static const char* l4proto_name(u16 prot
 	case IPPROTO_GRE: return "gre";
 	case IPPROTO_SCTP: return "sctp";
 	case IPPROTO_UDPLITE: return "udplite";
+	case IPPROTO_ICMPV6: return "icmpv6";
 	}
 
 	return "unknown";


