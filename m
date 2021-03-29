Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1334C88A
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhC2IXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233270AbhC2IVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B099E61554;
        Mon, 29 Mar 2021 08:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006079;
        bh=Qa5G5wdax085QRuIxKwFZtL3LCLuobDr38WuPDQeiR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJ3uKEXdlEjek0FAz7wLLxUaEE05HSRjDwk6icjzHmXUv6t3q28W/MACg2AmKNdcf
         iRSnWgGyqxZNNR2Vpn22IEEUaRVWDztwJKf1gCKBErxiaRlKzNxhYpyDkEpwJZ3OL+
         slUKiK3aXItIeS88QlLYO9+nw25HNlRD87/d6hec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/221] net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template
Date:   Mon, 29 Mar 2021 09:57:22 +0200
Message-Id: <20210329075632.916173766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit db74623a3850db99cb9692fda9e836a56b74198d ]

In qlcnic_83xx_get_minidump_template, fw_dump->tmpl_hdr was freed by
vfree(). But unfortunately, it is used when extended is true.

Fixes: 7061b2bdd620e ("qlogic: Deletion of unnecessary checks before two function calls")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
index 7760a3394e93..7ecb3dfe30bd 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
@@ -1425,6 +1425,7 @@ void qlcnic_83xx_get_minidump_template(struct qlcnic_adapter *adapter)
 
 	if (fw_dump->tmpl_hdr == NULL || current_version > prev_version) {
 		vfree(fw_dump->tmpl_hdr);
+		fw_dump->tmpl_hdr = NULL;
 
 		if (qlcnic_83xx_md_check_extended_dump_capability(adapter))
 			extended = !qlcnic_83xx_extend_md_capab(adapter);
@@ -1443,6 +1444,8 @@ void qlcnic_83xx_get_minidump_template(struct qlcnic_adapter *adapter)
 			struct qlcnic_83xx_dump_template_hdr *hdr;
 
 			hdr = fw_dump->tmpl_hdr;
+			if (!hdr)
+				return;
 			hdr->drv_cap_mask = 0x1f;
 			fw_dump->cap_mask = 0x1f;
 			dev_info(&pdev->dev,
-- 
2.30.1



