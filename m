Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2C1FBAC4
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgFPPm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgFPPmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8170B208D5;
        Tue, 16 Jun 2020 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322170;
        bh=2Mo54ugFbT/ZJzn0u2QHp9SXo5vCmvmm19JLQlDWKx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFUBO1VT1Cydf1yR1mble8E7GW9qBBrO4KpXhVn6At1dhHx8NhIHlpUrOomTWCaiP
         O6CcvROhKA8sW5CnaAPB0fZVcZ8ooqbJYbEziHeIi8crx5Wj9QRAf8HFS9N1ERmGwO
         uEk0NBd+CTr4/f27UCmxNmeovrQB0DkuYZnBDDS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 009/163] mptcp: bugfix for RM_ADDR option parsing
Date:   Tue, 16 Jun 2020 17:33:03 +0200
Message-Id: <20200616153107.310913641@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit 8e60eed6b38e464e8c9d68f9caecafaa554dffe0 ]

In MPTCPOPT_RM_ADDR option parsing, the pointer "ptr" pointed to the
"Subtype" octet, the pointer "ptr+1" pointed to the "Address ID" octet:

  +-------+-------+---------------+
  |Subtype|(resvd)|   Address ID  |
  +-------+-------+---------------+
  |               |
 ptr            ptr+1

We should set mp_opt->rm_id to the value of "ptr+1", not "ptr". This patch
will fix this bug.

Fixes: 3df523ab582c ("mptcp: Add ADD_ADDR handling")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -273,6 +273,8 @@ static void mptcp_parse_option(const str
 		if (opsize != TCPOLEN_MPTCP_RM_ADDR_BASE)
 			break;
 
+		ptr++;
+
 		mp_opt->rm_addr = 1;
 		mp_opt->rm_id = *ptr++;
 		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);


