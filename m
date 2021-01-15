Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39232F7A0E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbhAOMof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbhAOMiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C394A23356;
        Fri, 15 Jan 2021 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714288;
        bh=VJ6101fdYAlEMS5KFA2EGpLyJIVDmMtWMnzJfEDXdY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6EPnJRIx9taPcsWxs2qPjFdn/QyiFn84zWqIQ4QxNUTM9KsjDK872os4vB9yLUFg
         bfYPyVAfLEANA7vrXBmBmAJOj/E7WYHv0wHWIeRuPzH/GtQfpBiqQCjKf8qhG7OpSo
         RhsGJ2G9WJcibr0ovgxprqiYZynkLDU1V0DVlHHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 037/103] nexthop: Fix off-by-one error in error path
Date:   Fri, 15 Jan 2021 13:27:30 +0100
Message-Id: <20210115122007.852948035@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 07e61a979ca4dddb3661f59328b3cd109f6b0070 ]

A reference was not taken for the current nexthop entry, so do not try
to put it in the error path.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1277,7 +1277,7 @@ static struct nexthop *nexthop_create_gr
 	return nh;
 
 out_no_nh:
-	for (; i >= 0; --i)
+	for (i--; i >= 0; --i)
 		nexthop_put(nhg->nh_entries[i].nh);
 
 	kfree(nhg->spare);


