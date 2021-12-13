Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55559472517
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhLMJk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:40:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52734 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbhLMJjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:39:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19D85B80E2C;
        Mon, 13 Dec 2021 09:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC91C00446;
        Mon, 13 Dec 2021 09:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388357;
        bh=afMLMSWpIRUSLjedBJv/kgE3o/x0o6q2abLpiG3URec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfCrnGA72eV1g+u8aQnCigfazWFFllJ6sOG+VJPAb2zt35wX5geuz8rvzTTeIiIXx
         gjhefSlJQKNDgIoiFrVITKJaURqQ8VJmIq3njVEkYZLyX19gDzGJ7OCrDmUGiXkcpH
         3+vB8KkIcHtr6XW6Pzu0Ggxy98fMU2a8tsDCSGYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 21/74] udp: using datalen to cap max gso segments
Date:   Mon, 13 Dec 2021 10:29:52 +0100
Message-Id: <20211213092931.501210644@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

commit 158390e45612ef0fde160af0826f1740c36daf21 upstream.

The max number of UDP gso segments is intended to cap to UDP_MAX_SEGMENTS,
this is checked in udp_send_skb():

    if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
        kfree_skb(skb);
        return -EINVAL;
    }

skb->len contains network and transport header len here, we should use
only data len instead.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -798,7 +798,7 @@ static int udp_send_skb(struct sk_buff *
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
+		if (datalen > cork->gso_size * UDP_MAX_SEGMENTS) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}


