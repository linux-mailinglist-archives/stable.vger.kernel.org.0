Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BB61CAFBF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgEHNTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgEHMl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FD120731;
        Fri,  8 May 2020 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941687;
        bh=b3VoERAQ4vrSSvPWJX76nqPHID0l9PcTnCrzQK+/lsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvFD6bZ906AcP4OZO2xMTEK/K3XCwPNZCo2lo/hUWiMDe7h4i+/UMGkP6JSmTQ/BR
         FkyuwqWJF714JUSC7gnywiuqb3yRq4mxqyilsLCt1lcMHn6YPs75Uz5vSTjB2HpiO6
         PHZQFGv3VoL+COwRTGOtEDwwbHEMfHKj36UFF6Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 105/312] mlxsw: spectrum: Dont forward packets when STP state is DISABLED
Date:   Fri,  8 May 2020 14:31:36 +0200
Message-Id: <20200508123131.889688702@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

commit 9cb026ebb8ab76829a8d8e4bbd057168ac38fb86 upstream.

When STP state is set to DISABLED the port is assumed to be inactive, but
currently we forward packets ingressing through it.

Instead, set the port's STP state in hardware to DISCARDING, which means
it doesn't forward packets or perform any learning, but it does trap
control packets. However, these packets will be dropped by bridge code,
which results in the expected behavior.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -87,7 +87,6 @@ static int mlxsw_sp_port_stp_state_set(s
 	int err;
 
 	switch (state) {
-	case BR_STATE_DISABLED: /* fall-through */
 	case BR_STATE_FORWARDING:
 		spms_state = MLXSW_REG_SPMS_STATE_FORWARDING;
 		break;
@@ -95,6 +94,7 @@ static int mlxsw_sp_port_stp_state_set(s
 	case BR_STATE_LEARNING:
 		spms_state = MLXSW_REG_SPMS_STATE_LEARNING;
 		break;
+	case BR_STATE_DISABLED: /* fall-through */
 	case BR_STATE_BLOCKING:
 		spms_state = MLXSW_REG_SPMS_STATE_DISCARDING;
 		break;


