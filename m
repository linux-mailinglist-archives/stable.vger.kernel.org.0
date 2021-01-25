Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1B6302AAA
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbhAYSrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbhAYSrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48C820758;
        Mon, 25 Jan 2021 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600417;
        bh=OmS8k57oOtkGYpZcUdYAL9Z6Pfa2T5eSQu6mT+7b6uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxtmgCcl1fqxOl+JL7Vj43xKEN5NYdXn7yIejD3fDx0luJRHwScSyPneOqKx+kJFy
         3EqRXKwzTWbYHJuqcypTZdHUMhwrYm6Cx35ORKTwIm8hfAiZP1MFdiI5OwfbbJgAUy
         xJfMPQ7uP/ZhxGwdA8Ooz1E6nitMFjSMpxaiOOzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 81/86] ipv6: set multicast flag on the multicast route
Date:   Mon, 25 Jan 2021 19:40:03 +0100
Message-Id: <20210125183204.478274616@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
@@ -2452,7 +2452,7 @@ static void addrconf_add_mroute(struct n
 		.fc_ifindex = dev->ifindex,
 		.fc_dst_len = 8,
 		.fc_flags = RTF_UP,
-		.fc_type = RTN_UNICAST,
+		.fc_type = RTN_MULTICAST,
 		.fc_nlinfo.nl_net = dev_net(dev),
 		.fc_protocol = RTPROT_KERNEL,
 	};


