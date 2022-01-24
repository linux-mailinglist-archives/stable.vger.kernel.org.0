Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4991499542
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392501AbiAXUvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46322 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390455AbiAXUp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0724CB81057;
        Mon, 24 Jan 2022 20:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019EBC340E5;
        Mon, 24 Jan 2022 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057123;
        bh=6NOPhziuYypkTM6BA48wy+IPkpY4HrxLprlwRYabKag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnF0mqSdU1BLneWQpx//NPVmSAyTvEKlpA4fzWwlqO6XCWnvl/SXkRUGaUs34HOEu
         IFXbXFtrW2NO/fz5w7G1mtWQB5QAgmvgqN4PCmQcqFJZFw2O2Qq5FSIH9GioYV+LTR
         hM3t5jKnvTU4HXDCv6TshXF3HjYHGu/MpOl0cv5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 709/846] xfrm: fix dflt policy check when there is no policy configured
Date:   Mon, 24 Jan 2022 19:43:46 +0100
Message-Id: <20220124184125.491447877@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


