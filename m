Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7301719B3CC
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388131AbgDAQbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387891AbgDAQbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1572063A;
        Wed,  1 Apr 2020 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758683;
        bh=nxxjmfHFPYM72gWVUfqaUEcOMY8XzycG7P5OrOqHBFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL6YlUX7DmeNvq6fIlBm8T6j4C5gLBbVTUuGFkCjjN0d9nj47TjbMJzG1vMyEEem2
         BPW8FP0iUnz39RklBsLRiOInQtJfWJ8MdbVgix/2lIgSBFlrI+DBBbwcPekpzfrNXr
         I+nCTKiI75EpoT9dYvU+wJkQWphl0NYuEiBxkYJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 43/91] hsr: set .netnsok flag
Date:   Wed,  1 Apr 2020 18:17:39 +0200
Message-Id: <20200401161528.405213847@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 09e91dbea0aa32be02d8877bd50490813de56b9a ]

The hsr module has been supporting the list and status command.
(HSR_C_GET_NODE_LIST and HSR_C_GET_NODE_STATUS)
These commands send node information to the user-space via generic netlink.
But, in the non-init_net namespace, these commands are not allowed
because .netnsok flag is false.
So, there is no way to get node information in the non-init_net namespace.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -132,6 +132,7 @@ static struct genl_family hsr_genl_famil
 	.name = "HSR",
 	.version = 1,
 	.maxattr = HSR_A_MAX,
+	.netnsok = true,
 };
 
 static const struct genl_multicast_group hsr_mcgrps[] = {


