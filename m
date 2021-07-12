Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7F3C5BF7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhGLMSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 08:18:50 -0400
Received: from 8bytes.org ([81.169.241.247]:36222 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233885AbhGLMSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 08:18:48 -0400
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E5ABB259;
        Mon, 12 Jul 2021 14:15:58 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        thomas.lendacky@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH stable-5.4] crypto: ccp - Annotate SEV Firmware file names
Date:   Mon, 12 Jul 2021 14:12:50 +0200
Message-Id: <20210712121250.23392-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1626005849185115@kroah.com>
References: <1626005849185115@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit c8671c7dc7d51125ab9f651697866bf4a9132277 ]

Annotate the firmware files CCP might need using MODULE_FIRMWARE().
This will get them included into an initrd when CCP is also included
there. Otherwise the CCP module will not find its firmware when loaded
before the root-fs is mounted.
This can cause problems when the pre-loaded SEV firmware is too old to
support current SEV and SEV-ES virtualization features.

Fixes: e93720606efd ("crypto: ccp - Allow SEV firmware to be chosen based on Family and Model")
Cc: stable@vger.kernel.org # v4.20+
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/ccp/psp-dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 6b17d179ef8a..5acf6ae5af66 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -40,6 +40,10 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
+
 static bool psp_dead;
 static int psp_timeout;
 
-- 
2.31.1

