Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF80B3643B7
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240771AbhDSNVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241171AbhDSNUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D6961360;
        Mon, 19 Apr 2021 13:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838146;
        bh=ejUAZqMGKPGXwEmklG9FMFdemyZwfc4HRXSxVzTuR08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVrDX4Nq+imiP7OHkSJvkgNpbi5B6DdUvGybnWfM8lr0K5aitZCcXmo80Sod58UqP
         SHfTunEkenJTZeE2cm8C4XEySBMhPkFagLCwD+i5Wbraf32Tkxhojq+OAnL5ag0EYD
         09d5hJNeTLrChMIniv3CIqJjbHusM7G//1Y/MpLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 059/103] netfilter: conntrack: do not print icmpv6 as unknown via /proc
Date:   Mon, 19 Apr 2021 15:06:10 +0200
Message-Id: <20210419130529.835667269@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
@@ -266,6 +266,7 @@ static const char* l4proto_name(u16 prot
 	case IPPROTO_GRE: return "gre";
 	case IPPROTO_SCTP: return "sctp";
 	case IPPROTO_UDPLITE: return "udplite";
+	case IPPROTO_ICMPV6: return "icmpv6";
 	}
 
 	return "unknown";


