Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B199E2F7A06
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbhAOMoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:44:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388164AbhAOMiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3059236FB;
        Fri, 15 Jan 2021 12:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714290;
        bh=WKlYm6h0UNKbimFVNmrA4FQ36G3fzDbIf1QmBFHlYnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlHWwguh6EG1IqwEDFgy0xABUCeQB75E8YIvD1iMIyojiWpb54y+XmlbqMYsPKiWj
         P6yeNtvD5Sdc09/rNdSRzu/DWsnNltykVYuH8rQ19PCM3u5AX/NAWLhJg1J502A7sF
         06p4KPiSSsNb7Sw6wU6TPiv0WljNztCRJ3QFX43s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 038/103] nexthop: Unlink nexthop group entry in error path
Date:   Fri, 15 Jan 2021 13:27:31 +0100
Message-Id: <20210115122007.901310024@linuxfoundation.org>
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
@@ -1277,8 +1277,10 @@ static struct nexthop *nexthop_create_gr
 	return nh;
 
 out_no_nh:
-	for (i--; i >= 0; --i)
+	for (i--; i >= 0; --i) {
+		list_del(&nhg->nh_entries[i].nh_list);
 		nexthop_put(nhg->nh_entries[i].nh);
+	}
 
 	kfree(nhg->spare);
 	kfree(nhg);


