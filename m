Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFB82F7AAD
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbhAOMfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387729AbhAOMfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 891EB22473;
        Fri, 15 Jan 2021 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714101;
        bh=i6ABWXsCrVu9LoHnH+zYvSzYebHN7G8WuUf3UsGf2ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bkKTL0XotJSUo8fOBoTzgBNL1gDpyA2YOYzRWnPJd8TSWpo6lnuVo2lZtq1fY6pS
         jTrpvwaiHoOuAgWpCihJY/N2v5M5OlSK4YlJb/lEM2HKV8ODkTzekTSfoO6KLPyzrv
         W5SfGaiGAHi9jrXNl6+5MOmi0LfN9etGLYQDc7AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 16/62] nexthop: Unlink nexthop group entry in error path
Date:   Fri, 15 Jan 2021 13:27:38 +0100
Message-Id: <20210115121959.192657147@linuxfoundation.org>
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

[ Upstream commit 7b01e53eee6dce7a8a6736e06b99b68cd0cc7a27 ]

In case of error, remove the nexthop group entry from the list to which
it was previously added.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1157,8 +1157,10 @@ static struct nexthop *nexthop_create_gr
 	return nh;
 
 out_no_nh:
-	for (i--; i >= 0; --i)
+	for (i--; i >= 0; --i) {
+		list_del(&nhg->nh_entries[i].nh_list);
 		nexthop_put(nhg->nh_entries[i].nh);
+	}
 
 	kfree(nhg->spare);
 	kfree(nhg);


