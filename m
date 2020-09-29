Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62D427CC2E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732606AbgI2Mdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgI2LW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A8D323A6A;
        Tue, 29 Sep 2020 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378415;
        bh=wmCYoUD7YZie+IyY+8Memus+n+XyCcyOuyF4g+XQbXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/mwny7SVv/4EcUt3mLJICoN4aZWiK8qByGbuK0BC2GZFYqGP+knPGRDnvW3naeUZ
         PpRTrWcrtIjChXw0G94FyEcpYRVFsbMpmd908QiCdXj8InbqHpD2fsWvsRjCgvpWN2
         ehCAA4hZpqDEjt1EvogJECGase0NJIgFVN0se0nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 158/166] ALSA: asihpi: fix iounmap in error handler
Date:   Tue, 29 Sep 2020 13:01:10 +0200
Message-Id: <20200929105943.079046937@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 472eb39103e885f302fd8fd6eff104fcf5503f1b ]

clang static analysis flags this problem
hpioctl.c:513:7: warning: Branch condition evaluates to
  a garbage value
                if (pci.ap_mem_base[idx]) {
                    ^~~~~~~~~~~~~~~~~~~~

If there is a failure in the middle of the memory space loop,
only some of the memory spaces need to be cleaned up.

At the error handler, idx holds the number of successful
memory spaces mapped.  So rework the handler loop to use the
old idx.

There is a second problem, the memory space loop conditionally
iomaps()/sets the mem_base so it is necessay to initize pci.

Fixes: 719f82d3987a ("ALSA: Add support of AudioScience ASI boards")
Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20200913165230.17166-1-trix@redhat.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index b1a2a7ea41723..b4ccd9f92400e 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -350,7 +350,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 	struct hpi_message hm;
 	struct hpi_response hr;
 	struct hpi_adapter adapter;
-	struct hpi_pci pci;
+	struct hpi_pci pci = { 0 };
 
 	memset(&adapter, 0, sizeof(adapter));
 
@@ -506,7 +506,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 	return 0;
 
 err:
-	for (idx = 0; idx < HPI_MAX_ADAPTER_MEM_SPACES; idx++) {
+	while (--idx >= 0) {
 		if (pci.ap_mem_base[idx]) {
 			iounmap(pci.ap_mem_base[idx]);
 			pci.ap_mem_base[idx] = NULL;
-- 
2.25.1



