Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6320038ABA3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbhETL0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241171AbhETLWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:22:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE10F61438;
        Thu, 20 May 2021 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505505;
        bh=Y/xh6Xavdcp1CPtWYiw5QqH7hCEQh/7VA2kWDA+2bj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3zLjwPfGJvQqdruoiFpqhmqe1slUpvdXC+da8PADEg+joYXB/sd7uXLKZBcSbKsJ
         GT2WFqQ78L7peL+Jpf49EXcm6BABf1CEkK2ePRlCen4yvAINnaTDzX3DorhMkhJ2BD
         EOgBI2kf06RedGfeCZjSg414cT7Lrjlbkic8OL8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 148/190] sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
Date:   Thu, 20 May 2021 11:23:32 +0200
Message-Id: <20210520092107.075901822@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit e5272ad4aab347dde5610c0aedb786219e3ff793 ]

Fix the following out-of-bounds warning:

net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e3e44237de1c..9de03d2e5da9 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3119,7 +3119,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		 * primary.
 		 */
 		if (af->is_any(&addr))
-			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
+			memcpy(&addr, sctp_source(asconf), sizeof(addr));
 
 		peer = sctp_assoc_lookup_paddr(asoc, &addr);
 		if (!peer)
-- 
2.30.2



