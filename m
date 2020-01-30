Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6014E295
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgA3Slt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgA3Slq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5582083E;
        Thu, 30 Jan 2020 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409705;
        bh=SSZBkAhW4Il/TRVH99TGWnSXMPf9K7zc2YX6XuW3fdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9IyqasUdrcn3UZuItCyKVc7FCju985qeLSCXvW6+QpJhJ1LTg6ljbhREcWf18dDs
         uEugk9Oi20br6PJ5EepawAYIX2AlZj35OC1+0zll3YpWFCixhf5MIi92ixKKMtY4UD
         iacKfs/9S5b6qJB3eZ/i5CNk4jiJ4IeFbN3CkQ10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 36/56] mvneta driver disallow XDP program on hardware buffer management
Date:   Thu, 30 Jan 2020 19:38:53 +0100
Message-Id: <20200130183615.531603716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit 79572c98c554dcdb080bca547c871a51716dcdf8 ]

Recently XDP Support was added to the mvneta driver
for software buffer management only.
It is still possible to attach an XDP program if
hardware buffer management is used.
It is not doing anything at that point.

The patch disallows attaching XDP programs to mvneta
if hardware buffer management is used.

I am sorry about that. It is my first submission and I am having
some troubles with the format of my emails.

v4 -> v5:
- Remove extra tabs

v3 -> v4:
- Please ignore v3 I accidentally submitted
  my other patch with git-send-mail and v4 is correct

v2 -> v3:
- My mailserver corrupted the patch
  resubmission with git-send-email

v1 -> v2:
- Fixing the patches indentation

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4226,6 +4226,12 @@ static int mvneta_xdp_setup(struct net_d
 		return -EOPNOTSUPP;
 	}
 
+	if (pp->bm_priv) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Hardware Buffer Management not supported on XDP");
+		return -EOPNOTSUPP;
+	}
+
 	need_update = !!pp->xdp_prog != !!prog;
 	if (running && need_update)
 		mvneta_stop(dev);


