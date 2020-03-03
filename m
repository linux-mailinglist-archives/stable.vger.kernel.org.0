Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38817806A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgCCR4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732942AbgCCR4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48EF520728;
        Tue,  3 Mar 2020 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258199;
        bh=6baVSeaPeZngpOF0zDPEwvISGo1cuZHYG8DXixry+zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u72DMeE5ADaJ94R2neJvGyhBAvYGfmCFcyHp6Htzwo98BEZGYLkCLoeRUTQRT1MLo
         TvANQ8i6nwmhQdcAEz9abuAg7ceR+brkSRXh9VmPlT2iG0PuTz+UEzRqioBi2WrxFs
         P3WH2sGLeG14y31IvnvdWF6wHZTKDoekfH7ABNiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 109/152] net: atlantic: fix out of range usage of active_vlans array
Date:   Tue,  3 Mar 2020 18:43:27 +0100
Message-Id: <20200303174315.082944131@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

commit 5a292c89a84d49b598f8978f154bdda48b1072c0 upstream.

fix static checker warning:
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c:166 aq_check_approve_fvlan()
 error: passing untrusted data to 'test_bit()'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 7975d2aff5af: ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -158,7 +158,7 @@ aq_check_approve_fvlan(struct aq_nic_s *
 	}
 
 	if ((aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci),
+	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci) & VLAN_VID_MASK,
 		       aq_nic->active_vlans))) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: unknown vlan-id specified");


