Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9014049BBAB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiAYS6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:58:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18448 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233110AbiAYS6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 13:58:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PAe163008698;
        Tue, 25 Jan 2022 10:58:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kh8pGo1C1CdeIgY3h3mqcD43Q8Pk2XMUOQuTwYoONzw=;
 b=dQnoc0hq6eeLgwMli/bSsK4ihesKzZlp9/uKMccUbI0fa/PiZIwjIkZlbWqobxTJYrE+
 E0Mpelx10m7yM+Z8hbkS4uBL34G3lUKkKmHaokLMfgAQgNSTk0dPMTdtymvm23Gozovn
 zOpj41XLqG7xeWW9N8XWpWzYiYNb2xkz4vCHTyn1cPCbOrgjm4GelKt02luWkSOXa0nE
 rNDoMFrFOMepkgriGPBtJrINvr6PIwV2KJmOhe7nUoiTSAmm04efe9DjR/C4zUPGVVTE
 qLrqKZQAIAKkw8sFW/bx9ngHO1xx+eete3Ob0PbutvpdyBkVtDxWcF0fj20IIMiAHU8s Tg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dt8muk45p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 10:58:14 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 Jan
 2022 10:58:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 25 Jan 2022 10:58:12 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E484A5E6867;
        Tue, 25 Jan 2022 10:58:11 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20PIw6Dh026815;
        Tue, 25 Jan 2022 10:58:06 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20PIw1gO026814;
        Tue, 25 Jan 2022 10:58:01 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <stable@vger.kernel.org>
CC:     <aelior@marvell.com>, <gregkh@linuxfoundation.org>,
        <manishc@marvell.com>
Subject: [PATCH stable 5.16 2/2] bnx2x: Invalidate fastpath HSI version for VFs
Date:   Tue, 25 Jan 2022 10:57:49 -0800
Message-ID: <20220125185749.26774-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220125185749.26774-1-manishc@marvell.com>
References: <20220125185749.26774-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qwefb2x9qW0nIzQCFmo3uahWHWk69nWd
X-Proofpoint-GUID: qwefb2x9qW0nIzQCFmo3uahWHWk69nWd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 9c2f51f..052f7ff 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
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
-- 
1.8.3.1

