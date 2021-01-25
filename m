Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698FB3031A6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbhAYSyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731318AbhAYSyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6350D206B2;
        Mon, 25 Jan 2021 18:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600841;
        bh=tQS7MkKzUy2fb9DQ0buuRSVO960tXcRRI//U/S3+nLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRMOp3ikiIAwH1XxwpJPfJhaivWjeein2d4SBMBY4bipp/tcCwHyoL80SPirhtdNG
         m21LpYNJXU889jl7Gy++++QmfE65s+JsHhyuNjJocEHObL3GhcKXoCzMBMowKvRbbY
         ahp0B6t+Erq0ygv76Ljxtcy+wWcg88lm8au1q2u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 172/199] ipv6: create multicast route with RTPROT_KERNEL
Date:   Mon, 25 Jan 2021 19:39:54 +0100
Message-Id: <20210125183223.457280341@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

commit a826b04303a40d52439aa141035fca5654ccaccd upstream.

The ff00::/8 multicast route is created without specifying the fc_protocol
field, so the default RTPROT_BOOT value is used:

  $ ip -6 -d route
  unicast ::1 dev lo proto kernel scope global metric 256 pref medium
  unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
  unicast ff00::/8 dev eth0 proto boot scope global metric 256 pref medium

As the documentation says, this value identifies routes installed during
boot, but the route is created when interface is set up.
Change the value to RTPROT_KERNEL which is a better value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/addrconf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2468,6 +2468,7 @@ static void addrconf_add_mroute(struct n
 		.fc_flags = RTF_UP,
 		.fc_type = RTN_UNICAST,
 		.fc_nlinfo.nl_net = dev_net(dev),
+		.fc_protocol = RTPROT_KERNEL,
 	};
 
 	ipv6_addr_set(&cfg.fc_dst, htonl(0xFF000000), 0, 0, 0);


