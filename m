Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A742F7ABA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbhAOMx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:53:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387715AbhAOMfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A48923403;
        Fri, 15 Jan 2021 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714098;
        bh=jMzdF+RfhOwPd12eKVLrou4uv5cLdTnsfpiQ/dr7TyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUKFXVol2TMgZ+Qt9sI7t1FwybaAhz0HShRTsoAJl6JfLP8Oq2TT1WZ8T9PC0CueB
         eGgayDaV9AQlGDq6E2G4pt8sFPtyef1ZrdEyDBCZIphQxN5NThb/1KxllDJDnJ532c
         JVNESqzpBXWZAP7xiMb08MivC/3Eqtt7Ra7uElV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 15/62] nexthop: Fix off-by-one error in error path
Date:   Fri, 15 Jan 2021 13:27:37 +0100
Message-Id: <20210115121959.143541197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
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
@@ -1157,7 +1157,7 @@ static struct nexthop *nexthop_create_gr
 	return nh;
 
 out_no_nh:
-	for (; i >= 0; --i)
+	for (i--; i >= 0; --i)
 		nexthop_put(nhg->nh_entries[i].nh);
 
 	kfree(nhg->spare);


