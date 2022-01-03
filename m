Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4148327E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbiACO2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiACO1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:27:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8633C0613A5;
        Mon,  3 Jan 2022 06:27:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB6ED61123;
        Mon,  3 Jan 2022 14:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994D9C36AEE;
        Mon,  3 Jan 2022 14:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220036;
        bh=8rDkRL47WMlHdIagHXZwKR3Pclr3OqxqXZVbc6O+kOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ2Rmb+LoxoZ6DyvoElEmw6dAoEtojXDsbQhwYHWwlBdPeRnanN+OeXZPSTMrnFte
         +N11G5pkOB3mPE63Az130VIIBIe4Ogw3CQtboFOTE4Qtq9SAeccUKNBawsPueHT287
         5CiJCE2r9CTsyh63a54bTDc807mo/94vlmXyPvEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/37] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon,  3 Jan 2022 15:23:44 +0100
Message-Id: <20220103142052.079279703@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit eb66fb03a727cde0ab9b1a3858de55c26f3007da ]

This should be (res->end - res->start + 1) here actually,
use resource_size() derectly.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Link: https://lore.kernel.org/r/1639484316-75873-1-git-send-email-wangqing@vivo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/apple-gmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 7e3083deb1c5d..1b86005c0f5f4 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -625,7 +625,7 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_data->iostart = res->start;
-	gmux_data->iolen = res->end - res->start;
+	gmux_data->iolen = resource_size(res);
 
 	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
 		pr_err("gmux I/O region too small (%lu < %u)\n",
-- 
2.34.1



