Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2F1B0AD4
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgDTMva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgDTMsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:48:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 666552078E;
        Mon, 20 Apr 2020 12:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386896;
        bh=qaL4iYj7C80HTLE18s9gZmgPRTetzxaDAONH7zHUwiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5Tf/tYOA8DviEEEtu+RosTIN4hrGnCJx4DzZrOOMGyU4Undj5Oq18YgkNyGz4Xea
         gaQoUoKCz4JAA49fbrQds3QyLvSn13zDQC/bLswyEFER0bt8exbwEhn0gxHYaEvvB7
         ZPa3hOhQ3oIYJAssASXDtmkGjVOeM+nPrtrCljfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/40] hsr: check protocol version in hsr_newlink()
Date:   Mon, 20 Apr 2020 14:39:12 +0200
Message-Id: <20200420121449.830617851@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 4faab8c446def7667adf1f722456c2f4c304069c ]

In the current hsr code, only 0 and 1 protocol versions are valid.
But current hsr code doesn't check the version, which is received by
userspace.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1 version 4

In the test commands, version 4 is invalid.
So, the command should be failed.

After this patch, following error will occur.
"Error: hsr: Only versions 0..1 are supported."

Fixes: ee1c27977284 ("net/hsr: Added support for HSR v1")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_netlink.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -64,10 +64,16 @@ static int hsr_newlink(struct net *src_n
 	else
 		multicast_spec = nla_get_u8(data[IFLA_HSR_MULTICAST_SPEC]);
 
-	if (!data[IFLA_HSR_VERSION])
+	if (!data[IFLA_HSR_VERSION]) {
 		hsr_version = 0;
-	else
+	} else {
 		hsr_version = nla_get_u8(data[IFLA_HSR_VERSION]);
+		if (hsr_version > 1) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only versions 0..1 are supported");
+			return -EINVAL;
+		}
+	}
 
 	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version);
 }


