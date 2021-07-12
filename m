Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6FE3C4B82
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbhGLG5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240457AbhGLG4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F994611C2;
        Mon, 12 Jul 2021 06:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072839;
        bh=JkviBHPqCi8QAxRlbSP20AkebSw87cZ6oAY39ZKDxRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQpcbLcau/vMJ5M8Txh2b7BIaM1vWMFReh31chLb6eNbbC8ta2E77oJHtFZDKT9pi
         q5EahjIAH1KqDNku7cdBI3qw6uU6vV76MEWRrydoZxkzGQZ0voo4ndPMwcz1t5+RBF
         1XmawktyEILeolL0UjR7vwT3osiTfgfkk8l4nagA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.12 039/700] crypto: ccp - Annotate SEV Firmware file names
Date:   Mon, 12 Jul 2021 08:02:02 +0200
Message-Id: <20210712060930.179408595@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit c8671c7dc7d51125ab9f651697866bf4a9132277 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/sev-dev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -42,6 +42,10 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
+
 static bool psp_dead;
 static int psp_timeout;
 


