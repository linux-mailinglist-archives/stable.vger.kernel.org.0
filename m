Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB0240E688
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbhIPRUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347086AbhIPQ5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11C7261ADF;
        Thu, 16 Sep 2021 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809883;
        bh=EBbZEKk1Q8+0/FK1lc9ndXo46blG1XTr/+ky+ipJG2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prF4ZT5agBgpyIdQGek1yW1OSTk9LnP+V/atrPUHtxMqXGdGOuiM6ruK9dkp/hjB3
         44nLPkaygUsyBENGYQYAWYLgI3CedRVm6VTrOiv1D/ueCBFCddQufM4O2B3EqNznA6
         AP2gWlDKu2VHTNpmcV9qdnehCAJCzBIqWeExdKL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 286/380] selftests: nci: Fix the code for next nlattr offset
Date:   Thu, 16 Sep 2021 18:00:43 +0200
Message-Id: <20210916155813.804929496@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

[ Upstream commit 78a7b2a8a0fa31f63ac16ac13601db6ed8259dfc ]

nlattr could have a padding for 4 bytes alignment. So next nla's offset
should be calculated with a padding.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 57b505cb1561..9687100f15ea 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -113,8 +113,8 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		if (nla_len > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
-		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
-		prv_len = na->nla_len;
+		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
+		msg.n.nlmsg_len += prv_len;
 	}
 
 	buf = (char *)&msg;
-- 
2.30.2



