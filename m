Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B062F7988
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbhAOMhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388036AbhAOMhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED10323356;
        Fri, 15 Jan 2021 12:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714222;
        bh=fVftOZ3FvMhYPI/2X17NxjKeTATjtxglSj3hylaaX58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBF3iznAPzMFmp0y/uis/zPOP1D1cHZQ12bY0UqtSIwh/Rc3O0NhO6uvYg1Fv9/72
         HlZMaH1rLSXdeTlH8q1/kbgjtpFDSwi2RqzH1CCsBww9bkWWrokj0AOvakjCpx29f5
         Q3emR0lql9bV19shQwyXlusSaHQ5G9cR7Ihzw9jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 039/103] nexthop: Bounce NHA_GATEWAY in FDB nexthop groups
Date:   Fri, 15 Jan 2021 13:27:32 +0100
Message-Id: <20210115122007.949280095@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit b19218b27f3477316d296e8bcf4446aaf017aa69 ]

The function nh_check_attr_group() is called to validate nexthop groups.
The intention of that code seems to have been to bounce all attributes
above NHA_GROUP_TYPE except for NHA_FDB. However instead it bounces all
these attributes except when NHA_FDB attribute is present--then it accepts
them.

NHA_FDB validation that takes place before, in rtm_to_nh_config(), already
bounces NHA_OIF, NHA_BLACKHOLE, NHA_ENCAP and NHA_ENCAP_TYPE. Yet further
back, NHA_GROUPS and NHA_MASTER are bounced unconditionally.

But that still leaves NHA_GATEWAY as an attribute that would be accepted in
FDB nexthop groups (with no meaning), so long as it keeps the address
family as unspecified:

 # ip nexthop add id 1 fdb via 127.0.0.1
 # ip nexthop add id 10 fdb via default group 1

The nexthop code is still relatively new and likely not used very broadly,
and the FDB bits are newer still. Even though there is a reproducer out
there, it relies on an improbable gateway arguments "via default", "via
all" or "via any". Given all this, I believe it is OK to reformulate the
condition to do the right thing and bounce NHA_GATEWAY.

Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -496,7 +496,7 @@ static int nh_check_attr_group(struct ne
 	for (i = NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
-		if (tb[NHA_FDB])
+		if (i == NHA_FDB)
 			continue;
 		NL_SET_ERR_MSG(extack,
 			       "No other attributes can be set in nexthop groups");


