Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD82C9B6A
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbgLAJIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgLAJIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7092C21D46;
        Tue,  1 Dec 2020 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813649;
        bh=50yd1u6iPrFppC8uI9SEv2TSO/9i/T9PeeCFpCq5ZLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhAaFWkKP6goa0P9hs4+gBXl+eBHTNQ4ge5RrWjtK+7h5VgyAD3+rtNoykIrprJTh
         YrLMD+Q/k2mmYmmylDggesnPIKG6nW1D+iKhql+/RHBN6+55xtaADXFZZcZYH+4Z2b
         Yhue9/neFtnogJe6WsbWryvdyMqbt0YFgiP8Dhfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@arm.com>,
        Florian Klink <flokli@flokli.de>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 005/152] ipv4: use IS_ENABLED instead of ifdef
Date:   Tue,  1 Dec 2020 09:52:00 +0100
Message-Id: <20201201084712.358338824@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Klink <flokli@flokli.de>

commit c09c8a27b9baa417864b9adc3228b10ae5eeec93 upstream.

Checking for ifdef CONFIG_x fails if CONFIG_x=m.

Use IS_ENABLED instead, which is true for both built-ins and modules.

Otherwise, a
> ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1
fails with the message "Error: IPv6 support not enabled in kernel." if
CONFIG_IPV6 is `m`.

In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.

Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
Cc: Kim Phillips <kim.phillips@arm.com>
Signed-off-by: Florian Klink <flokli@flokli.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20201115224509.2020651-1-flokli@flokli.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/fib_frontend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -696,7 +696,7 @@ int fib_gw_from_via(struct fib_config *c
 		cfg->fc_gw4 = *((__be32 *)via->rtvia_addr);
 		break;
 	case AF_INET6:
-#ifdef CONFIG_IPV6
+#if IS_ENABLED(CONFIG_IPV6)
 		if (alen != sizeof(struct in6_addr)) {
 			NL_SET_ERR_MSG(extack, "Invalid IPv6 address in RTA_VIA");
 			return -EINVAL;


