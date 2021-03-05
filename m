Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3183232E89D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCEM15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhCEM1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:27:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10EF36502C;
        Fri,  5 Mar 2021 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947251;
        bh=hY3xVA+oiIZJBdhz3mp6d4HCxLU0AgSsc+4M3oM5fMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlQ35ON9V89lvNRKa7OOSGHPyB0sKXDeE4oLdXMnt4ngOVKXNytpNwUUcgoqFx9kj
         YyrcuZDXSROT/eCp5pdOxld96tuFMNhsmAj4UgJObNQ9moLeGVg40ITH0mJQM7JW9x
         h/ZLlNDna63Ki4DfdKXNFsQamnQRuTxx03JwCtKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.das@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 064/104] PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse
Date:   Fri,  5 Mar 2021 13:21:09 +0100
Message-Id: <20210305120906.316239825@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 907830b0fc9e374d00f3c83de5e426157b482c01 ]

RX 5600 XT Pulse advertises support for BAR 0 being 256MB, 512MB,
or 1GB, but it also supports 2GB, 4GB, and 8GB. Add a rebar
size quirk so that the BAR 0 is big enough to cover complete VARM.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20210107175017.15893-5-nirmoy.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 790393d1e318..ba791165ed19 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3596,7 +3596,14 @@ u32 pci_rebar_get_possible_sizes(struct pci_dev *pdev, int bar)
 		return 0;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CAP, &cap);
-	return (cap & PCI_REBAR_CAP_SIZES) >> 4;
+	cap &= PCI_REBAR_CAP_SIZES;
+
+	/* Sapphire RX 5600 XT Pulse has an invalid cap dword for BAR 0 */
+	if (pdev->vendor == PCI_VENDOR_ID_ATI && pdev->device == 0x731f &&
+	    bar == 0 && cap == 0x7000)
+		cap = 0x3f000;
+
+	return cap >> 4;
 }
 
 /**
-- 
2.30.1



