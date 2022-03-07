Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8654CF733
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbiCGJo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241061AbiCGJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E36E6D953;
        Mon,  7 Mar 2022 01:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E79F7B80F9F;
        Mon,  7 Mar 2022 09:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573ADC340F3;
        Mon,  7 Mar 2022 09:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645981;
        bh=nQvkdzM2YBwqxdxMmCeSg7GZgPuxTQOZqpEjIrd4Ekc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKBP9eLcVNuP+9kpZz7cF6vkBYpEMd7p08pA9+0lmxQ77NqiBJopwWqfZ+ryunRdA
         0LHaTdm80r6d1/Shfp9PQor2g/uYyrKocE2HcV5sp6NalTrHvJKfqx8dLh2uy5ldEX
         b2Zm5o30LtSRxEF7jyIAE3YrYsHrC4V+ONWgLrY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/262] drm/amdgpu: filter out radeon secondary ids as well
Date:   Mon,  7 Mar 2022 10:17:22 +0100
Message-Id: <20220307091705.246592441@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 9e5a14bce2402e84251a10269df0235cd7ce9234 ]

Older radeon boards (r2xx-r5xx) had secondary PCI functions
which we solely there for supporting multi-head on OSs with
special requirements.  Add them to the unsupported list
as well so we don't attempt to bind to them.  The driver
would fail to bind to them anyway, but this does so
in a cleaner way that should not confuse the user.

Cc: stable@vger.kernel.org
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 81 +++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 82bb3e80219cd..5a7fef324c820 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1519,6 +1519,87 @@ static const u16 amdgpu_unsupported_pciidlist[] = {
 	0x99A0,
 	0x99A2,
 	0x99A4,
+	/* radeon secondary ids */
+	0x3171,
+	0x3e70,
+	0x4164,
+	0x4165,
+	0x4166,
+	0x4168,
+	0x4170,
+	0x4171,
+	0x4172,
+	0x4173,
+	0x496e,
+	0x4a69,
+	0x4a6a,
+	0x4a6b,
+	0x4a70,
+	0x4a74,
+	0x4b69,
+	0x4b6b,
+	0x4b6c,
+	0x4c6e,
+	0x4e64,
+	0x4e65,
+	0x4e66,
+	0x4e67,
+	0x4e68,
+	0x4e69,
+	0x4e6a,
+	0x4e71,
+	0x4f73,
+	0x5569,
+	0x556b,
+	0x556d,
+	0x556f,
+	0x5571,
+	0x5854,
+	0x5874,
+	0x5940,
+	0x5941,
+	0x5b72,
+	0x5b73,
+	0x5b74,
+	0x5b75,
+	0x5d44,
+	0x5d45,
+	0x5d6d,
+	0x5d6f,
+	0x5d72,
+	0x5d77,
+	0x5e6b,
+	0x5e6d,
+	0x7120,
+	0x7124,
+	0x7129,
+	0x712e,
+	0x712f,
+	0x7162,
+	0x7163,
+	0x7166,
+	0x7167,
+	0x7172,
+	0x7173,
+	0x71a0,
+	0x71a1,
+	0x71a3,
+	0x71a7,
+	0x71bb,
+	0x71e0,
+	0x71e1,
+	0x71e2,
+	0x71e6,
+	0x71e7,
+	0x71f2,
+	0x7269,
+	0x726b,
+	0x726e,
+	0x72a0,
+	0x72a8,
+	0x72b1,
+	0x72b3,
+	0x793f,
 };
 
 static const struct pci_device_id pciidlist[] = {
-- 
2.34.1



