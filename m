Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7E84A9638
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357767AbiBDJYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42556 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357559AbiBDJXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AB8615ED;
        Fri,  4 Feb 2022 09:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745DEC004E1;
        Fri,  4 Feb 2022 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966596;
        bh=VXigYRW5rsIpfXUUUjWJOkU9kJ0Hj9Zg+9vR2xZfuw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2g3iP4BuKP3yDYHzOXeWR2phR8FmXC9q5OcDi4DcaTMCa2r5UYFfM5EvmgnWjC6W
         vYxjnQLIsfduIbB1dsSbh4PbQNo3NBMmAv1j/vDHdZjbC8NcXcWQMiOA0lnlQJwco4
         inT2brMdwIAcKWUFjsSm2B3ZaY2NihYTBLvQCIkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 13/32] net/mlx5: Bridge, ensure dev_name is null-terminated
Date:   Fri,  4 Feb 2022 10:22:23 +0100
Message-Id: <20220204091915.702289475@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

commit 350d9a823734b5a7e767cddc3bdde5f0bcbb7ff4 upstream.

Even though net_device->name is guaranteed to be null-terminated string of
size<=IFNAMSIZ, the test robot complains that return value of netdev_name()
can be larger:

In file included from include/trace/define_trace.h:102,
                    from drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h:113,
                    from drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c:12:
   drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h: In function 'trace_event_raw_event_mlx5_esw_bridge_fdb_template':
>> drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h:24:29: warning: 'strncpy' output may be truncated copying 16 bytes from a string of length 20 [-Wstringop-truncation]
      24 |                             strncpy(__entry->dev_name,
         |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~
      25 |                                     netdev_name(fdb->dev),
         |                                     ~~~~~~~~~~~~~~~~~~~~~~
      26 |                                     IFNAMSIZ);
         |                                     ~~~~~~~~~

This is caused by the fact that default value of IFNAMSIZ is 16, while
placeholder value that is returned by netdev_name() for unnamed net devices
is larger than that.

The offending code is in a tracing function that is only called for mlx5
representors, so there is no straightforward way to reproduce the issue but
let's fix it for correctness sake by replacing strncpy() with strscpy() to
ensure that resulting string is always null-terminated.

Fixes: 9724fd5d9c2a ("net/mlx5: Bridge, add tracepoints")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
@@ -21,7 +21,7 @@ DECLARE_EVENT_CLASS(mlx5_esw_bridge_fdb_
 			    __field(unsigned int, used)
 			    ),
 		    TP_fast_assign(
-			    strncpy(__entry->dev_name,
+			    strscpy(__entry->dev_name,
 				    netdev_name(fdb->dev),
 				    IFNAMSIZ);
 			    memcpy(__entry->addr, fdb->key.addr, ETH_ALEN);


