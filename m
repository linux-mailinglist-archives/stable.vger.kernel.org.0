Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44061304B5C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbhAZErB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbhAYSnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C26020758;
        Mon, 25 Jan 2021 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600192;
        bh=5ouj24M92o2Slflk/I2RALDkr/hw054fGgyUg3PWdgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPlKS8EXL6Pwn69+u1cXKvtkQCxcuqOIGC+o4k8HVPpT6QZgj9I4E4YfkfGNkVVkr
         taRBJwqKA1Wi+dQiomG4ut0020bqEv0h7yv4z3KKju56S6RuPRXL5+I60+gfNgZaZH
         WVHlIBiYkRImT/ixJyqse2lUIdDxn+Mfznd/a4uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 58/58] net: dsa: b53: fix an off by one in checking "vlan->vid"
Date:   Mon, 25 Jan 2021 19:39:59 +0100
Message-Id: <20210125183159.182015559@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8e4052c32d6b4b39c1e13c652c7e33748d447409 upstream.

The > comparison should be >= to prevent accessing one element beyond
the end of the dev->vlans[] array in the caller function, b53_vlan_add().
The "dev->vlans" array is allocated in the b53_switch_init() function
and it has "dev->num_vlans" elements.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/YAbxI97Dl/pmBy5V@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/b53/b53_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1142,7 +1142,7 @@ int b53_vlan_prepare(struct dsa_switch *
 	if ((is5325(dev) || is5365(dev)) && vlan->vid_begin == 0)
 		return -EOPNOTSUPP;
 
-	if (vlan->vid_end > dev->num_vlans)
+	if (vlan->vid_end >= dev->num_vlans)
 		return -ERANGE;
 
 	b53_enable_vlan(dev, true, dev->vlan_filtering_enabled);


