Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043C949E9E6
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245228AbiA0SKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47680 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245255AbiA0SKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7107761BC5;
        Thu, 27 Jan 2022 18:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A988C340E4;
        Thu, 27 Jan 2022 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307021;
        bh=/SpOvRAzSZuL3nSSYY7xGjur0CIUWNo9JKuuksvoas8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FreiJf06OcFR//a41Bjn8oEt0bAKex/WfL7DRWcfUOyZUPxu3DZUYZ4gpuPhnln5u
         POA5QEdAA/v617/FpvfEk6YKnnE8u++ZpB6AD288um2+6yD+ZyracaCoY5//jipdWt
         Ku/eV5Cp83Jpay+cvw8+IIdrvPrTI2Luac1ETh/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manish Chopra <manishc@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 3/6] bnx2x: Invalidate fastpath HSI version for VFs
Date:   Thu, 27 Jan 2022 19:09:19 +0100
Message-Id: <20220127180258.247298538@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
References: <20220127180258.131170405@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

commit 802d4d207e75d7208ff75adb712b556c1e91cf1c upstream

Commit 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
added validation for fastpath HSI versions for different
client init which was not meant for SR-IOV VF clients, which
resulted in firmware asserts when running VF clients with
different fastpath HSI version.

This patch along with the new firmware support in patch #1
fixes this behavior in order to not validate fastpath HSI
version for the VFs.

Fixes: 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bn
 
 void bnx2x_vf_enable_access(struct bnx2x *bp, u8 abs_vfid)
 {
+	u16 abs_fid;
+
+	abs_fid = FW_VF_HANDLE(abs_vfid);
+
 	/* set the VF-PF association in the FW */
-	storm_memset_vf_to_pf(bp, FW_VF_HANDLE(abs_vfid), BP_FUNC(bp));
-	storm_memset_func_en(bp, FW_VF_HANDLE(abs_vfid), 1);
+	storm_memset_vf_to_pf(bp, abs_fid, BP_FUNC(bp));
+	storm_memset_func_en(bp, abs_fid, 1);
+
+	/* Invalidate fp_hsi version for vfs */
+	if (bp->fw_cap & FW_CAP_INVALIDATE_VF_FP_HSI)
+		REG_WR8(bp, BAR_XSTRORM_INTMEM +
+			    XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
 
 	/* clear vf errors*/
 	bnx2x_vf_semi_clear_err(bp, abs_vfid);


