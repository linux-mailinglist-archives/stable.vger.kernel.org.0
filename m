Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F5514B685
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgA1OF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbgA1OF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6762E2468A;
        Tue, 28 Jan 2020 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220327;
        bh=p99L67TBU8jVHLId7ZCRFvMml//FY6jErV0aGLQrcvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvXGz8++l0i1lQXJ38AfJ7T3j54u5+wV/ele6oFsV8RQrKtjK6618ZC92hmYTaKRa
         jErw6J1hHEYjcsxTbEjcwbCaJIy0rnUZfz9DFdgb0sCHthMbkMg1ptEUxaAqx2oL4l
         8I3BEoksA/eIrWnwpMAN453jqv+l/sMqJLTWw2WI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulrich Weber <ulrich.weber@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 083/104] xfrm: support output_mark for offload ESP packets
Date:   Tue, 28 Jan 2020 15:00:44 +0100
Message-Id: <20200128135828.650597485@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulrich Weber <ulrich.weber@gmail.com>

commit 4e4362d2bf2a49ff44dbbc9585207977ca3d71d0 upstream.

Commit 9b42c1f179a6 ("xfrm: Extend the output_mark") added output_mark
support but missed ESP offload support.

xfrm_smark_get() is not called within xfrm_input() for packets coming
from esp4_gro_receive() or esp6_gro_receive(). Therefore call
xfrm_smark_get() directly within these functions.

Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
Signed-off-by: Ulrich Weber <ulrich.weber@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/esp4_offload.c |    2 ++
 net/ipv6/esp6_offload.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -57,6 +57,8 @@ static struct sk_buff *esp4_gro_receive(
 		if (!x)
 			goto out_reset;
 
+		skb->mark = xfrm_smark_get(skb->mark, x);
+
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
 
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -79,6 +79,8 @@ static struct sk_buff *esp6_gro_receive(
 		if (!x)
 			goto out_reset;
 
+		skb->mark = xfrm_smark_get(skb->mark, x);
+
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
 


