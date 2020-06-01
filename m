Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203551EAC37
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgFASQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbgFASQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 314A120776;
        Mon,  1 Jun 2020 18:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035408;
        bh=jMoiX+JGTBCMU7QJU91KJpkrlSuZHrgN8R4EYldhycg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whU75/Bu8NiOdonJendgVFfwzNP+/wMUMXd6mkjx7/LvIAWb+qwB5dXaCMbI0jfAi
         Lyd+140+Etj7c6iKF0b1V+DYlD8s1r8cXpME4jmiUTzbtLGW1fXw9vJRN0+BBccEhX
         7KmR01Su1gG2H/p2sijAOgdbxMNrlWjpDpaBHI5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.6 146/177] xfrm: remove the xfrm_state_put call becofe going to out_reset
Date:   Mon,  1 Jun 2020 19:54:44 +0200
Message-Id: <20200601174100.628363008@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit db87668ad1e4917cfe04e217307ba6ed9390716e upstream.

This xfrm_state_put call in esp4/6_gro_receive() will cause
double put for state, as in out_reset path secpath_reset()
will put all states set in skb sec_path.

So fix it by simply remove the xfrm_state_put call.

Fixes: 6ed69184ed9c ("xfrm: Reset secpath in xfrm failure")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/esp4_offload.c |    4 +---
 net/ipv6/esp6_offload.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -63,10 +63,8 @@ static struct sk_buff *esp4_gro_receive(
 		sp->olen++;
 
 		xo = xfrm_offload(skb);
-		if (!xo) {
-			xfrm_state_put(x);
+		if (!xo)
 			goto out_reset;
-		}
 	}
 
 	xo->flags |= XFRM_GRO;
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -85,10 +85,8 @@ static struct sk_buff *esp6_gro_receive(
 		sp->olen++;
 
 		xo = xfrm_offload(skb);
-		if (!xo) {
-			xfrm_state_put(x);
+		if (!xo)
 			goto out_reset;
-		}
 	}
 
 	xo->flags |= XFRM_GRO;


