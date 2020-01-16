Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9937313F1FF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391971AbgAPScI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:32:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391869AbgAPRZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7CB246CA;
        Thu, 16 Jan 2020 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195504;
        bh=QWQJxnLDkNt1oRoE6sADWy1w2Gz/H+uoEqJBl4/Yang=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcKoPn013Gw9RDQr0H//zSXHOOVShK9gBsshpMPBMubyxoACCI7bLg81wMDQNFW5K
         0AVDGeavDBpsheu+hyEwQCCeht9tRH/HEiz/FmhXVpNXNgM+YyNHJgKrcOivETpob5
         3OU3ap6wJTE0/Ceyh7vxtsa6MwY5jUTe750k/X2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Mc Guire <hofrat@osadl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.14 104/371] staging: r8822be: check kzalloc return or bail
Date:   Thu, 16 Jan 2020 12:19:36 -0500
Message-Id: <20200116172403.18149-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit e4b08e16b7d9d030b6475ef48f94d734a39f3c81 ]

The kzalloc() in halmac_parse_psd_data_88xx() can fail and return NULL
so check the psd_set->data after allocation and if allocation failed
return HALMAC_CMD_PROCESS_ERROR.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: 938a0447f094 ("staging: r8822be: Add code for halmac sub-drive")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c    | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c b/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
index 544f638ed3ef..15091ee587db 100644
--- a/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
+++ b/drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c
@@ -2492,8 +2492,11 @@ halmac_parse_psd_data_88xx(struct halmac_adapter *halmac_adapter, u8 *c2h_buf,
 	segment_size = (u8)PSD_DATA_GET_SEGMENT_SIZE(c2h_buf);
 	psd_set->data_size = total_size;
 
-	if (!psd_set->data)
+	if (!psd_set->data) {
 		psd_set->data = kzalloc(psd_set->data_size, GFP_KERNEL);
+		if (!psd_set->data)
+			return HALMAC_CMD_PROCESS_ERROR;
+	}
 
 	if (segment_id == 0)
 		psd_set->segment_size = segment_size;
-- 
2.20.1

