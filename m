Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC86C12F0EC
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgABW4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgABWRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E171322314;
        Thu,  2 Jan 2020 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003471;
        bh=p3mN6/BO5IBOxZGR65xlpM+u9W8WRUgft2jFWJ41u7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VydE8dllimaOs/kTCgA/r/Dh+ot/FeY5qcLaRTP9et+wgd+xLNk8Erw9xAGGgdgIb
         PhPHAOCekGarDcHsVoQuo3a5zmJL94wp1GDPmTOV+PjForI2shsEz3FlJkkJBXxVED
         FOZF/VO/zbpezqFcfLjqDP/e7WgoXZcXqLN92BeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 148/191] net: dsa: bcm_sf2: Fix IP fragment location and behavior
Date:   Thu,  2 Jan 2020 23:07:10 +0100
Message-Id: <20200102215845.368774557@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7c3125f0a6ebc17846c5908ad7d6056d66c1c426 ]

The IP fragment is specified through user-defined field as the first
bit of the first user-defined word. We were previously trying to extract
it from the user-defined mask which could not possibly work. The ip_frag
is also supposed to be a boolean, if we do not cast it as such, we risk
overwriting the next fields in CFP_DATA(6) which would render the rule
inoperative.

Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2_cfp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -358,7 +358,7 @@ static int bcm_sf2_cfp_ipv4_rule_set(str
 		return -EINVAL;
 	}
 
-	ip_frag = be32_to_cpu(fs->m_ext.data[0]);
+	ip_frag = !!(be32_to_cpu(fs->h_ext.data[0]) & 1);
 
 	/* Locate the first rule available */
 	if (fs->location == RX_CLS_LOC_ANY)
@@ -569,7 +569,7 @@ static int bcm_sf2_cfp_rule_cmp(struct b
 
 		if (rule->fs.flow_type != fs->flow_type ||
 		    rule->fs.ring_cookie != fs->ring_cookie ||
-		    rule->fs.m_ext.data[0] != fs->m_ext.data[0])
+		    rule->fs.h_ext.data[0] != fs->h_ext.data[0])
 			continue;
 
 		switch (fs->flow_type & ~FLOW_EXT) {
@@ -621,7 +621,7 @@ static int bcm_sf2_cfp_ipv6_rule_set(str
 		return -EINVAL;
 	}
 
-	ip_frag = be32_to_cpu(fs->m_ext.data[0]);
+	ip_frag = !!(be32_to_cpu(fs->h_ext.data[0]) & 1);
 
 	layout = &udf_tcpip6_layout;
 	slice_num = bcm_sf2_get_slice_number(layout, 0);


