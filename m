Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4F4A4382
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376439AbiAaLVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37264 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376565AbiAaLRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 260B0B82A68;
        Mon, 31 Jan 2022 11:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1C4C340E8;
        Mon, 31 Jan 2022 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627848;
        bh=yb1nodQINQS6Zb0tcPMW6RUzDoyt+MuWeOVVx3otRO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUUWT/vnm0uCnYyFtmSWmmXZEkiSOnr16hpvaNiN9QKIFjabZF3K0YwRQ+Ua7EcMP
         0AYcl2kJChUzYSz2j+TwHJFTcmz+3OxbLYm6IVnV7DHihhXUUSzmUyVuw3Kv+wwkoo
         8RiYadO/poeazjbJXPkqW9QvdxzivtpFAPibGviU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 044/200] drm/amdgpu: filter out radeon secondary ids as well
Date:   Mon, 31 Jan 2022 11:55:07 +0100
Message-Id: <20220131105235.041585043@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 9e5a14bce2402e84251a10269df0235cd7ce9234 upstream.

Older radeon boards (r2xx-r5xx) had secondary PCI functions
which we solely there for supporting multi-head on OSs with
special requirements.  Add them to the unsupported list
as well so we don't attempt to bind to them.  The driver
would fail to bind to them anyway, but this does so
in a cleaner way that should not confuse the user.

Cc: stable@vger.kernel.org
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   81 ++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1523,6 +1523,87 @@ static const u16 amdgpu_unsupported_pcii
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


