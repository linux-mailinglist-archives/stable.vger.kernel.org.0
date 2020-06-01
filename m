Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6CA1EAAD8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgFASL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730754AbgFASL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4163C20776;
        Mon,  1 Jun 2020 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035118;
        bh=Jzhk2Jep2Ej1UIoC9Bin7Re5JWpsfWDcmtSHejPa6JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ne2hxQ9+VyEFLGkKnZxxUGkB9MByKwLjW0czJxdPwRY6jxEK70sIaVNzlzjrkU9DT
         vToamBkZ+mvjl7JIzmyHaxtq+bPAkK2V1uSQIuH/a6+z9XWDkH7we+lYWhTycTEr3Q
         OazFUjxprdbWwLKWDpIU44FIFJUP17Xe/lldN9YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ASSOGBA Emery <assogba.emery@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 018/177] nexthop: Fix attribute checking for groups
Date:   Mon,  1 Jun 2020 19:52:36 +0200
Message-Id: <20200601174050.204297493@linuxfoundation.org>
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
@@ -434,7 +434,7 @@ static int nh_check_attr_group(struct ne
 		if (!valid_group_nh(nh, len, extack))
 			return -EINVAL;
 	}
-	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
+	for (i = NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
 


