Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943DC30C0A6
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhBBODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233620AbhBBOB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:01:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5302964F81;
        Tue,  2 Feb 2021 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273631;
        bh=cpZaEV4Z4loEYPob1cRqK00H21Vm0SfB0SmJH7r+UP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwDkSHY0KRRPnG8y7bjiBkG6Qzci/kfWiqpwfrQFsSooluKarLkeuT13krI0b5Taj
         cE7StdLmKxoTyQvik701Jg9leC3rHQAdyHGgX92rJ5fJRDIen3F+j0gmc/zOlMPBdj
         sIe2WJ+y3h/fz0DzhwscO5V2qMDO5UDQJxu2HbrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/61] xfrm: fix disable_xfrm sysctl when used on xfrm interfaces
Date:   Tue,  2 Feb 2021 14:38:12 +0100
Message-Id: <20210202132947.908755639@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit 9f8550e4bd9d78a8436c2061ad2530215f875376 ]

The disable_xfrm flag signals that xfrm should not be performed during
routing towards a device before reaching device xmit.

For xfrm interfaces this is usually desired as they perform the outbound
policy lookup as part of their xmit using their if_id.

Before this change enabling this flag on xfrm interfaces prevented them
from xmitting as xfrm_lookup_with_ifid() would not perform a policy lookup
in case the original dst had the DST_NOXFRM flag.

This optimization is incorrect when the lookup is done by the xfrm
interface xmit logic.

Fix by performing policy lookup when invoked by xfrmi as if_id != 0.

Similarly it's unlikely for the 'no policy exists on net' check to yield
any performance benefits when invoked from xfrmi.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 2917711ff8ab6..780e96f0708e2 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3065,8 +3065,8 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 		xflo.flags = flags;
 
 		/* To accelerate a bit...  */
-		if ((dst_orig->flags & DST_NOXFRM) ||
-		    !net->xfrm.policy_count[XFRM_POLICY_OUT])
+		if (!if_id && ((dst_orig->flags & DST_NOXFRM) ||
+			       !net->xfrm.policy_count[XFRM_POLICY_OUT]))
 			goto nopol;
 
 		xdst = xfrm_bundle_lookup(net, fl, family, dir, &xflo, if_id);
-- 
2.27.0



