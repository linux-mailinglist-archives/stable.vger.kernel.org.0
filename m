Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7B11CABE9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgEHMsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgEHMsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43B6E2145D;
        Fri,  8 May 2020 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942086;
        bh=riBXK0KZYBwehtc18Vx1x5TT8z5aF7XvhRxqXWTNihE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mlbv2WubWKeSD+/nfqS+I7CSkD7q/+wmP/8+CzkeuuNyDnCz+PMnfO5JcESU8HMSR
         9c5scDQ1jKPZkKLMsx8ZPYOzD7oRufuepHq2MIOjnT/bidiMLUxBvvInHV8d6FinUQ
         m3T9Y153q0m52kFsISAsVt679rKHeNeEtiIKpBCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Libosvar <jlibosva@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 291/312] net: vxlan: lwt: Fix vxlan local traffic.
Date:   Fri,  8 May 2020 14:34:42 +0200
Message-Id: <20200508123144.843469094@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: pravin shelar <pshelar@ovn.org>

commit bbec7802c6948c8626b71a4fe31283cb4691c358 upstream.

vxlan driver has bypass for local vxlan traffic, but that
depends on information about all VNIs on local system in
vxlan driver. This is not available in case of LWT.
Therefore following patch disable encap bypass for LWT
vxlan traffic.

Fixes: ee122c79d42 ("vxlan: Flow based tunneling").
Reported-by: Jakub Libosvar <jlibosva@redhat.com>
Signed-off-by: Pravin B Shelar <pshelar@ovn.org>
Acked-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/vxlan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2054,7 +2054,7 @@ static void vxlan_xmit_one(struct sk_buf
 		}
 
 		/* Bypass encapsulation if the destination is local */
-		if (rt->rt_flags & RTCF_LOCAL &&
+		if (!info && rt->rt_flags & RTCF_LOCAL &&
 		    !(rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 			struct vxlan_dev *dst_vxlan;
 
@@ -2112,7 +2112,7 @@ static void vxlan_xmit_one(struct sk_buf
 
 		/* Bypass encapsulation if the destination is local */
 		rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
-		if (rt6i_flags & RTF_LOCAL &&
+		if (!info && rt6i_flags & RTF_LOCAL &&
 		    !(rt6i_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 			struct vxlan_dev *dst_vxlan;
 


