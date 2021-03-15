Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E4C33B8E7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhCOOEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232399AbhCON6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 784D764F1A;
        Mon, 15 Mar 2021 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816708;
        bh=zpNUKK/aPKyGPqxpwHHm0Ond1XIcDiwIFmzE1PWTR9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6TALwkKxTxTbMBVOPUQD0dsGnWKo7uJ/h3Ry4Y0pAqy102+1EO222zIQCJ9IhkHq
         Tz3+y2uUinCDzM4kaptEH1eW4dyj0ruLuEjXnG55E9TpM5ClDSmbANsKCqR8sV66tM
         QqVFYMETzyf+HynAvQlqjwPQGhUR7U8YGelRxOhk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony@phenome.org>,
        Shannon Nelson <snelson@pensando.io>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 077/306] ixgbe: fail to create xfrm offload of IPsec tunnel mode SA
Date:   Mon, 15 Mar 2021 14:52:20 +0100
Message-Id: <20210315135510.244205815@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Antony Antony <antony@phenome.org>

commit d785e1fec60179f534fbe8d006c890e5ad186e51 upstream.

Based on talks and indirect references ixgbe IPsec offlod do not
support IPsec tunnel mode offload. It can only support IPsec transport
mode offload. Now explicitly fail when creating non transport mode SA
with offload to avoid false performance expectations.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Antony Antony <antony@phenome.org>
Acked-by: Shannon Nelson <snelson@pensando.io>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c |    5 +++++
 drivers/net/ethernet/intel/ixgbevf/ipsec.c     |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -575,6 +575,11 @@ static int ixgbe_ipsec_add_sa(struct xfr
 		return -EINVAL;
 	}
 
+	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
+		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		return -EINVAL;
+	}
+
 	if (ixgbe_ipsec_check_mgmt_ip(xs)) {
 		netdev_err(dev, "IPsec IP addr clash with mgmt filters\n");
 		return -EINVAL;
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -272,6 +272,11 @@ static int ixgbevf_ipsec_add_sa(struct x
 		return -EINVAL;
 	}
 
+	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
+		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		return -EINVAL;
+	}
+
 	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		struct rx_sa rsa;
 


