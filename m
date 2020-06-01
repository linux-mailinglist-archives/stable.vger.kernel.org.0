Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A27E1EAF20
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgFAR45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728739AbgFAR44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2ADE2074B;
        Mon,  1 Jun 2020 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034216;
        bh=mSzzVs0ISvJewz8D+bFmYMyXw5XU/Wy5slLZ24po0nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng89Nfd1HRERQjIb9bUSJ9LNGC1fY71YpzfqnTmiDvLDdzjzx8L1sQiwnrbc4sAVd
         AFHM+3birm82AMDXbOiIhSTavKYmYBY3UYU5vrLp0Fvm2VMIIPp/zS8zDM0VUzhBUH
         cypa01H0CIeOhPrKoOBD1xH6h0z+/n66CGs2XcPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam mcbirnie <liam.mcbirnie@boeing.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 44/48] net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags
Date:   Mon,  1 Jun 2020 19:53:54 +0200
Message-Id: <20200601174004.785945749@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

commit 56a49d7048703f5ffdb84d3a0ee034108fba6850 upstream.

This fix addresses https://bugzilla.kernel.org/show_bug.cgi?id=201071

Commit 5025f7f7d506 wrongly relied on __dev_change_flags to notify users of
dev flag changes in the case when dev->rtnl_link_state = RTNL_LINK_INITIALIZED.
Fix it by indicating flag changes explicitly to __dev_notify_flags.

Fixes: 5025f7f7d506 ("rtnetlink: add rtnl_link_state check in rtnl_configure_link")
Reported-By: Liam mcbirnie <liam.mcbirnie@boeing.com>
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/rtnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2105,7 +2105,7 @@ int rtnl_configure_link(struct net_devic
 	}
 
 	if (dev->rtnl_link_state == RTNL_LINK_INITIALIZED) {
-		__dev_notify_flags(dev, old_flags, 0U);
+		__dev_notify_flags(dev, old_flags, (old_flags ^ dev->flags));
 	} else {
 		dev->rtnl_link_state = RTNL_LINK_INITIALIZED;
 		__dev_notify_flags(dev, old_flags, ~0U);


