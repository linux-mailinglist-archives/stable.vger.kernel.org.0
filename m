Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85FE2F14DE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbhAKNb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbhAKNPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74041225AC;
        Mon, 11 Jan 2021 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370889;
        bh=qgonb/oF0Wnlp/y6P7LJTKtvexIxDr4oWRdKBi+emkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoNBzkcZ2jk/cyaisVSzQvNq11K237PPy5GSC2VyfbhD5hNcyZfAf1/u7R+F9lNsz
         g58lV5yodBntGfHtGro9QjSeJgtf6w5IZwQeh4FfIMpm62ZK12GGLJQSI5OiyuHUOD
         K2zXkuDxOCRl/XRP18/gPWz4mxC1b57pnOeb8ztI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 048/145] selftests: mlxsw: Set headroom size of correct port
Date:   Mon, 11 Jan 2021 14:01:12 +0100
Message-Id: <20210111130050.832623753@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 2ff2c7e274392871bfdee00ff2adbb8ebae5d240 ]

The test was setting the headroom size of the wrong port. This was not
visible because of a firmware bug that canceled this bug.

Set the headroom size of the correct port, so that the test will pass
with both old and new firmware versions.

Fixes: bfa804784e32 ("selftests: mlxsw: Add a PFC test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20201230114251.394009-1-idosch@idosch.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
@@ -230,7 +230,7 @@ switch_create()
 	__mlnx_qos -i $swp4 --pfc=0,1,0,0,0,0,0,0 >/dev/null
 	# PG0 will get autoconfigured to Xoff, give PG1 arbitrarily 100K, which
 	# is (-2*MTU) about 80K of delay provision.
-	__mlnx_qos -i $swp3 --buffer_size=0,$_100KB,0,0,0,0,0,0 >/dev/null
+	__mlnx_qos -i $swp4 --buffer_size=0,$_100KB,0,0,0,0,0,0 >/dev/null
 
 	# bridges
 	# -------


