Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C789138D4
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfEDK0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbfEDK0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90EB020859;
        Sat,  4 May 2019 10:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965614;
        bh=d3kskyLJYes5YWw6IU1MrMwjhax9xWRa3YcLQXscwE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb6Ti6NMfIhoaJ1QTeeOLL17ZvOgJbwPhkBoDeXd4XQK/mbMBl3IFahbTLUlNWS4M
         rQxonJSmubNvVjJdOB/nya4VXn3Cfgd9A3zBN+BEFN7KW9YnjK5eeBS1c0pTgAhAYd
         DJ4cQ2dKd0IL+DCdezWJVHbq8mu8frsXL9QKTpkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 08/32] net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc
Date:   Sat,  4 May 2019 12:24:53 +0200
Message-Id: <20190504102452.794161677@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f949a12fd697479f68d99dc65e9bbab68ee49043 ]

The "fs->location" is a u32 that comes from the user in ethtool_set_rxnfc().
We can't pass unclamped values to test_bit() or it results in an out of
bounds access beyond the end of the bitmap.

Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2_cfp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -854,6 +854,9 @@ static int bcm_sf2_cfp_rule_set(struct d
 	     fs->m_ext.data[1]))
 		return -EINVAL;
 
+	if (fs->location != RX_CLS_LOC_ANY && fs->location >= CFP_NUM_RULES)
+		return -EINVAL;
+
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    test_bit(fs->location, priv->cfp.used))
 		return -EBUSY;
@@ -942,6 +945,9 @@ static int bcm_sf2_cfp_rule_del(struct b
 	struct cfp_rule *rule;
 	int ret;
 
+	if (loc >= CFP_NUM_RULES)
+		return -EINVAL;
+
 	/* Refuse deleting unused rules, and those that are not unique since
 	 * that could leave IPv6 rules with one of the chained rule in the
 	 * table.


