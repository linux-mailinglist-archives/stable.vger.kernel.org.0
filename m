Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B365278863
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgIYMyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbgIYMyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2DF3206DB;
        Fri, 25 Sep 2020 12:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038492;
        bh=oCEO3l2SqYTgG5TOA0nDptZZvjG6lrB864tuU+mM7Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kT1hJ9B90MkA0kqQfUGcNJWsS1h1/d9HHcTQC2RdAoYOACg2YU5PTMIayeQZ2G+yg
         SHURK4XBF3vH7fRyVXYO9KqpF6M3FYf0sH1PQFKCd2vWJeQ1eEiVQRTvLVuLMkefDG
         uOAWTxgvEH03PUdCPHZAPEjNxggVqkBvxTCd1lHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/37] net: DCB: Validate DCB_ATTR_DCB_BUFFER argument
Date:   Fri, 25 Sep 2020 14:48:38 +0200
Message-Id: <20200925124722.503844295@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 297e77e53eadb332d5062913447b104a772dc33b ]

The parameter passed via DCB_ATTR_DCB_BUFFER is a struct dcbnl_buffer. The
field prio2buffer is an array of IEEE_8021Q_MAX_PRIORITIES bytes, where
each value is a number of a buffer to direct that priority's traffic to.
That value is however never validated to lie within the bounds set by
DCBX_MAX_BUFFERS. The only driver that currently implements the callback is
mlx5 (maintainers CCd), and that does not do any validation either, in
particual allowing incorrect configuration if the prio2buffer value does
not fit into 4 bits.

Instead of offloading the need to validate the buffer index to drivers, do
it right there in core, and bounce the request if the value is too large.

CC: Parav Pandit <parav@nvidia.com>
CC: Saeed Mahameed <saeedm@nvidia.com>
Fixes: e549f6f9c098 ("net/dcb: Add dcbnl buffer attribute")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dcb/dcbnl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1421,6 +1421,7 @@ static int dcbnl_ieee_set(struct net_dev
 {
 	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
 	struct nlattr *ieee[DCB_ATTR_IEEE_MAX + 1];
+	int prio;
 	int err;
 
 	if (!ops)
@@ -1469,6 +1470,13 @@ static int dcbnl_ieee_set(struct net_dev
 		struct dcbnl_buffer *buffer =
 			nla_data(ieee[DCB_ATTR_DCB_BUFFER]);
 
+		for (prio = 0; prio < ARRAY_SIZE(buffer->prio2buffer); prio++) {
+			if (buffer->prio2buffer[prio] >= DCBX_MAX_BUFFERS) {
+				err = -EINVAL;
+				goto err;
+			}
+		}
+
 		err = ops->dcbnl_setbuffer(netdev, buffer);
 		if (err)
 			goto err;


