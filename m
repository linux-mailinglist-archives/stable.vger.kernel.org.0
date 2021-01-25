Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E42304A8A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbhAZFFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbhAYSyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9FB02100A;
        Mon, 25 Jan 2021 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600851;
        bh=37+VVziomjouwaSdoeRU8YHsmhhn22D6yU59bF/mXbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3REbXdOhpiRwfXRA/wsd7CfsZwsjmI/aqwwGNO2VMWbEaleZrIwc844YQpr5KVnj
         FS4DxoZvzPborku08CdfGNAYJGMdB4LMr1QlLyhgt3mqKIXhuVP650PRC0Fc6yJs8E
         4vdVX/6q82nje5lDnBWe1sS1C4MKj2+9HVZdr3dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 175/199] ipv6: set multicast flag on the multicast route
Date:   Mon, 25 Jan 2021 19:39:57 +0100
Message-Id: <20210125183223.587285191@linuxfoundation.org>
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

commit ceed9038b2783d14e0422bdc6fd04f70580efb4c upstream.

The multicast route ff00::/8 is created with type RTN_UNICAST:

  $ ip -6 -d route
  unicast ::1 dev lo proto kernel scope global metric 256 pref medium
  unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
  unicast ff00::/8 dev eth0 proto kernel scope global metric 256 pref medium

Set the type to RTN_MULTICAST which is more appropriate.

Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/addrconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2466,7 +2466,7 @@ static void addrconf_add_mroute(struct n
 		.fc_ifindex = dev->ifindex,
 		.fc_dst_len = 8,
 		.fc_flags = RTF_UP,
-		.fc_type = RTN_UNICAST,
+		.fc_type = RTN_MULTICAST,
 		.fc_nlinfo.nl_net = dev_net(dev),
 		.fc_protocol = RTPROT_KERNEL,
 	};


