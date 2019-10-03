Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2044CAC3F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732930AbfJCQHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732093AbfJCQHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:07:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A328215EA;
        Thu,  3 Oct 2019 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118841;
        bh=LoLT/BNnw/82HhhkcwYdCMddbzY+ZbKn7J/2db9xysE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjcq/zl3dbTO5El9WQGN2Y4B1GYmPnQpSuushlseDf4RWfGMBHrRmUkU7W6734oJZ
         t69T6MRfOe3hOIDFaBqG16qN4CKZ12ib4t6WKviFK6DQMevFPcC48eRAvAZXrYKjsK
         UGYJRNrUs7N884+ZcrlhmMugpD/gvM/0C79RfZOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 029/185] net: dont warn in inet diag when IPV6 is disabled
Date:   Thu,  3 Oct 2019 17:51:47 +0200
Message-Id: <20191003154444.335235900@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 1e64d7cbfdce4887008314d5b367209582223f27 ]

If IPV6 was disabled, then ss command would cause a kernel warning
because the command was attempting to dump IPV6 socket information.
The fix is to just remove the warning.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202249
Fixes: 432490f9d455 ("net: ip, diag -- Add diag interface for raw sockets")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/raw_diag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index c200065ef9a5e..6367ecdf76c42 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -23,9 +23,6 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
 		return &raw_v6_hashinfo;
 #endif
 	} else {
-		pr_warn_once("Unexpected inet family %d\n",
-			     r->sdiag_family);
-		WARN_ON_ONCE(1);
 		return ERR_PTR(-EINVAL);
 	}
 }
-- 
2.20.1



