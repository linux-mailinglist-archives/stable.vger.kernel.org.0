Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704A54D7C2
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfFTSKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfFTSKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:10:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 107992089C;
        Thu, 20 Jun 2019 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054205;
        bh=UfCHc50+h/K+slCE7JCcG0jyf/MlE1PR41uhQPQgYXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ga1wiDRwJW40f/xB24wfTe0xZ/6M4jZYvaq7/t7XEPh7d8pW6co5neH6YXqdT8tlf
         m4v7No629wAi6rWXpV3TmNLzOJ7w8WeYCHOVsqLvr/k/Iuo0mk5AdHIUX4X7sdJR8X
         Ql/xZLrRRNJk8xQ0wQ6rNZov2VxLkpJr25p9CBAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao <tizhao@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/61] be2net: Fix number of Rx queues used for flow hashing
Date:   Thu, 20 Jun 2019 19:56:57 +0200
Message-Id: <20190620174337.840765030@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 718f4a2537089ea41903bf357071306163bc7c04 ]

Number of Rx queues used for flow hashing returned by the driver is
incorrect and this bug prevents user to use the last Rx queue in
indirection table.

Let's say we have a NIC with 6 combined queues:

[root@sm-03 ~]# ethtool -l enp4s0f0
Channel parameters for enp4s0f0:
Pre-set maximums:
RX:             5
TX:             5
Other:          0
Combined:       6
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       6

Default indirection table maps all (6) queues equally but the driver
reports only 5 rings available.

[root@sm-03 ~]# ethtool -x enp4s0f0
RX flow hash indirection table for enp4s0f0 with 5 RX ring(s):
    0:      0     1     2     3     4     5     0     1
    8:      2     3     4     5     0     1     2     3
   16:      4     5     0     1     2     3     4     5
   24:      0     1     2     3     4     5     0     1
...

Now change indirection table somehow:

[root@sm-03 ~]# ethtool -X enp4s0f0 weight 1 1
[root@sm-03 ~]# ethtool -x enp4s0f0
RX flow hash indirection table for enp4s0f0 with 6 RX ring(s):
    0:      0     0     0     0     0     0     0     0
...
   64:      1     1     1     1     1     1     1     1
...

Now it is not possible to change mapping back to equal (default) state:

[root@sm-03 ~]# ethtool -X enp4s0f0 equal 6
Cannot set RX flow hash configuration: Invalid argument

Fixes: 594ad54a2c3b ("be2net: Add support for setting and getting rx flow hash options")
Reported-by: Tianhao <tizhao@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/emulex/benet/be_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1105,7 +1105,7 @@ static int be_get_rxnfc(struct net_devic
 		cmd->data = be_get_rss_hash_opts(adapter, cmd->flow_type);
 		break;
 	case ETHTOOL_GRXRINGS:
-		cmd->data = adapter->num_rx_qs - 1;
+		cmd->data = adapter->num_rx_qs;
 		break;
 	default:
 		return -EINVAL;


