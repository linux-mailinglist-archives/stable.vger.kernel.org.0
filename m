Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7048A3832A4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239929AbhEQOuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240381AbhEQOsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:48:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C2461972;
        Mon, 17 May 2021 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261332;
        bh=Txb9QZFGcZN2o+Xs36hw9Zd477/Y0ILGOccjIZDxASo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfvRyOQGsD3eHjWXCJvDdU95eNJcfhxZfX5FRkNlyEO2b1A3kw7qAoW2l9ah9cp6q
         Cza9/n3twwbv9IgkH+7tWlKWsOgrpdRqMaHBm6yiPWPWL68eKy6yQVE0mzau+QDyRf
         YM/qbUtq23rtsAuAGmzy2YW2tlu2ioXbqQraqGiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/141] sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
Date:   Mon, 17 May 2021 16:01:26 +0200
Message-Id: <20210517140243.917189916@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index d5eda966a706..4ffb9116b6f2 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3134,7 +3134,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		 * primary.
 		 */
 		if (af->is_any(&addr))
-			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
+			memcpy(&addr, sctp_source(asconf), sizeof(addr));
 
 		if (security_sctp_bind_connect(asoc->ep->base.sk,
 					       SCTP_PARAM_SET_PRIMARY,
-- 
2.30.2



