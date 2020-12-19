Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A022DEF12
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgLSM6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgLSM6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.9 09/49] net: hns3: remove a misused pragma packed
Date:   Sat, 19 Dec 2020 13:58:13 +0100
Message-Id: <20201219125345.131206644@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 61f54de2e9194f01874d5eda12037b0978e77519 ]

hclge_dbg_reg_info[] is defined as an array of packed structure
accidentally. However, this array contains pointers, which are
no longer aligned naturally, and cannot be relocated on PPC64.
Hence, when compile-testing this driver on PPC64 with
CONFIG_RELOCATABLE=y (e.g. PowerPC allyesconfig), there will be
some warnings.

Since each field in structure hclge_qos_pri_map_cmd and
hclge_dbg_bitmap_cmd is type u8, the pragma packed is unnecessary
for these two structures as well, so remove the pragma packed in
hclge_debugfs.h to fix this issue, and this increases
hclge_dbg_reg_info[] by 4 bytes per entry.

Fixes: a582b78dfc33 ("net: hns3: code optimization for debugfs related to "dump reg"")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -35,8 +35,6 @@
 
 #define HCLGE_DBG_DFX_SSU_2_OFFSET 12
 
-#pragma pack(1)
-
 struct hclge_qos_pri_map_cmd {
 	u8 pri0_tc  : 4,
 	   pri1_tc  : 4;
@@ -85,8 +83,6 @@ struct hclge_dbg_reg_type_info {
 	struct hclge_dbg_reg_common_msg reg_msg;
 };
 
-#pragma pack()
-
 static struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
 	{false, "Reserved"},
 	{true,	"BP_CPU_STATE"},


