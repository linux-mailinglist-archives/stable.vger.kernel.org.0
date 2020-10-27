Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC6D29B744
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799358AbgJ0PbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799350AbgJ0PbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40CF122202;
        Tue, 27 Oct 2020 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812662;
        bh=12y8q7aEKSwb76n0CihYuhN4cmOjbCftB3Xa/GANJMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjXEuJ2aWonhVzlx4s3/nXC/rNJqdRI0uNX+/sKr0VzB1BLaEy/Vp1grmqtjZs5am
         zwVLVSJsigH51YKZYkQWzoYWfd9Ea05EExVs+z2RcduL/Iq8GlA8UEhMX9HNDIuoj1
         qNa+fvB2is16Y4oAHEIXho+zzCMImBdOGaR8MVZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 288/757] net: dsa: rtl8366: Check validity of passed VLANs
Date:   Tue, 27 Oct 2020 14:48:58 +0100
Message-Id: <20201027135504.080247772@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 6641a2c42b0a307b7638d10e5d4b90debc61389d ]

The rtl8366_set_vlan() and rtl8366_set_pvid() get invalid
VLANs tossed at it, especially VLAN0, something the hardware
and driver cannot handle. Check validity and bail out like
we do in the other callbacks.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index a8c5a934c3d30..f75a660fcb620 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -43,6 +43,9 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	dev_dbg(smi->dev,
 		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, member, untag);
@@ -118,6 +121,9 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	/* Try to find an existing MC entry for this VID */
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-- 
2.25.1



