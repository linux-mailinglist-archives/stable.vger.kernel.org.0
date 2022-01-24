Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98878499B43
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574930AbiAXVup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55434 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351335AbiAXVhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C6EC614CB;
        Mon, 24 Jan 2022 21:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EC7C340E4;
        Mon, 24 Jan 2022 21:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060228;
        bh=6NOPhziuYypkTM6BA48wy+IPkpY4HrxLprlwRYabKag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2s8EQ5tDgKINW0xkfXCgv9EKE5NzrGTUKVIFw5i1C5cHEwUA0RD6dIIGznK0XgddG
         mlBZOw/k1z2hRLL6wv9zZhwECQK03C+mEA9VxPAZeZlv1liMm7xip3YVPFdT4G/I6J
         3IXKt3hs2VsfOy17KRRxJNMcPh7y/7ezcbXmV1To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.16 0881/1039] xfrm: fix dflt policy check when there is no policy configured
Date:   Mon, 24 Jan 2022 19:44:30 +0100
Message-Id: <20220124184154.909528381@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit ec3bb890817e4398f2d46e12e2e205495b116be9 upstream.

When there is no policy configured on the system, the default policy is
checked in xfrm_route_forward. However, it was done with the wrong
direction (XFRM_POLICY_FWD instead of XFRM_POLICY_OUT).
The default policy for XFRM_POLICY_FWD was checked just before, with a call
to xfrm[46]_policy_check().

CC: stable@vger.kernel.org
Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xfrm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1167,7 +1167,7 @@ static inline int xfrm_route_forward(str
 {
 	struct net *net = dev_net(skb->dev);
 
-	if (xfrm_default_allow(net, XFRM_POLICY_FWD))
+	if (xfrm_default_allow(net, XFRM_POLICY_OUT))
 		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
 			(skb_dst(skb)->flags & DST_NOXFRM) ||
 			__xfrm_route_forward(skb, family);


