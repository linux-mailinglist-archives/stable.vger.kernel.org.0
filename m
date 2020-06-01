Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2250C1EAA7C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgFASI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730742AbgFASI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:08:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD7122068D;
        Mon,  1 Jun 2020 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034908;
        bh=rarwAHqrjgn7Om4YPhznCvWP4IzKyrx4sWUE+jY6K7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkB4jEWeSg/PR5uA5N2DXVcQqx+1PjS5N6New1ijvVyEWv7Uer5cZRDMb7KeyJC1p
         c9d1Ad6oTD0i1jd4cSA8GRdDsQO76Bp2/WVqujKHF6aULteTbVIiPHvIrP4wp537DF
         I6QTIk3rORK8u0s52w1UAIkjZotZaX4w2vyzq/QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ASSOGBA Emery <assogba.emery@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 016/142] nexthop: Fix attribute checking for groups
Date:   Mon,  1 Jun 2020 19:52:54 +0200
Message-Id: <20200601174039.581323711@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 84be69b869a5a496a6cfde9b3c29509207a1f1fa ]

For nexthop groups, attributes after NHA_GROUP_TYPE are invalid, but
nh_check_attr_group starts checking at NHA_GROUP. The group type defaults
to multipath and the NHA_GROUP_TYPE is currently optional so this has
slipped through so far. Fix the attribute checking to handle support of
new group types.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: ASSOGBA Emery <assogba.emery@gmail.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -435,7 +435,7 @@ static int nh_check_attr_group(struct ne
 		if (!valid_group_nh(nh, len, extack))
 			return -EINVAL;
 	}
-	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
+	for (i = NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
 


