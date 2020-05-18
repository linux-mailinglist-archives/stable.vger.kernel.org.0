Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF61D85EF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgERSWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730721AbgERRux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26FE120826;
        Mon, 18 May 2020 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824252;
        bh=fE4l/YiFzGqBGD1qlBVhUzgpbiM6XFdUJWqpCgy6Krk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dd7S/zyem6cQlEgG3GICtblWa3wrLNL3l7rMJ2VZRt0YP8GPS5sIzFHapJcTkd92X
         8Uo4KL/k2j8u1FcbMYE4LfG39bQ3W8+JSZGQWaFYwzdDCSipsAu99nQQ35qRYAxriE
         MaFVPL2/Una8lhul1G2LZmrY6IdgdPWfnMlyqG14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Walters <walters@redhat.com>
Subject: [PATCH 4.19 18/80] net: ipv4: really enforce backoff for redirects
Date:   Mon, 18 May 2020 19:36:36 +0200
Message-Id: <20200518173454.103849772@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 57644431a6c2faac5d754ebd35780cf43a531b1a ]

In commit b406472b5ad7 ("net: ipv4: avoid mixed n_redirects and
rate_tokens usage") I missed the fact that a 0 'rate_tokens' will
bypass the backoff algorithm.

Since rate_tokens is cleared after a redirect silence, and never
incremented on redirects, if the host keeps receiving packets
requiring redirect it will reply ignoring the backoff.

Additionally, the 'rate_last' field will be updated with the
cadence of the ingress packet requiring redirect. If that rate is
high enough, that will prevent the host from generating any
other kind of ICMP messages

The check for a zero 'rate_tokens' value was likely a shortcut
to avoid the more complex backoff algorithm after a redirect
silence period. Address the issue checking for 'n_redirects'
instead, which is incremented on successful redirect, and
does not interfere with other ICMP replies.

Fixes: b406472b5ad7 ("net: ipv4: avoid mixed n_redirects and rate_tokens usage")
Reported-and-tested-by: Colin Walters <walters@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -906,7 +906,7 @@ void ip_rt_send_redirect(struct sk_buff
 	/* Check for load limit; set rate_last to the latest sent
 	 * redirect.
 	 */
-	if (peer->rate_tokens == 0 ||
+	if (peer->n_redirects == 0 ||
 	    time_after(jiffies,
 		       (peer->rate_last +
 			(ip_rt_redirect_load << peer->n_redirects)))) {


