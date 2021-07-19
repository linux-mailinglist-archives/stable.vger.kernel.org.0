Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4D03CE5EE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348763AbhGSPzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350480AbhGSPvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F02E560FD8;
        Mon, 19 Jul 2021 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712171;
        bh=5l+CbeNtFNMZRmjXjvby5K20xdEF5yT9XL4lP0yvdsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sft6gWiOMiXB5I1S1dqRplQesLKkkU5A5WrqIimeGJFbFBiQlojswtmk/lxcLAP52
         D+s3264FmKc1NWWuNI7gRMXJT+RL9IRiLfoaroJWSkaK2/ma8RtKCI+4I88XrJm48w
         KmkyAm67nlg9ovPyL0pCOto9CmCpq3FucfojhOg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 278/292] scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()
Date:   Mon, 19 Jul 2021 16:55:40 +0200
Message-Id: <20210719144952.061172604@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 030e4138d11fced3b831c2761e4cecf347bae99c ]

If an error occurs after a pci_enable_pcie_error_reporting() call, it must
be undone by a corresponding pci_disable_pcie_error_reporting() call, as
already done in the remove function.

Link: https://lore.kernel.org/r/77adb02cfea7f1364e5603ecf3930d8597ae356e.1623482155.git.christophe.jaillet@wanadoo.fr
Fixes: 3567f36a09d1 ("[SCSI] be2iscsi: Fix AER handling in driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 09d2f8351539..207e3f53c638 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5745,6 +5745,7 @@ free_hba:
 	pci_disable_msix(phba->pcidev);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_disable_pcie_error_reporting(pcidev);
 	pci_set_drvdata(pcidev, NULL);
 disable_pci:
 	pci_release_regions(pcidev);
-- 
2.30.2



