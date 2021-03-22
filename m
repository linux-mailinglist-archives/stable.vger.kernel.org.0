Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56934411C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhCVMa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhCVMa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE48C6198D;
        Mon, 22 Mar 2021 12:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416226;
        bh=SXHQvMorEmMwC1N/79KQkKOaRK29rlKveMKefQhRZXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZocziY2NA/BfS4ovLFSIIEFd6GjmKmRj4EiSduL2TJ87Wu3v9N7QpfeKrcTSkWBT
         z+WK6zaXUOmWrz0OTirwVay0hUvrvCI3n4QfGy7CyfeSOC8rtd5ACgbWk0yw1D6QWJ
         DUJoefznXpMJGpt60HuGVTmxxAS+feSR1X7jRiAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.11 026/120] iommu/amd: Dont call early_amd_iommu_init() when AMD IOMMU is disabled
Date:   Mon, 22 Mar 2021 13:26:49 +0100
Message-Id: <20210322121930.531825437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 9f81ca8d1fd68f5697c201f26632ed622e9e462f upstream.

Don't even try to initialize the AMD IOMMU hardware when amd_iommu=off has been
passed on the kernel command line.

Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20210317091037.31374-3-joro@8bytes.org
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2917,12 +2917,12 @@ static int __init state_next(void)
 		}
 		break;
 	case IOMMU_IVRS_DETECTED:
-		ret = early_amd_iommu_init();
-		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_ACPI_FINISHED;
-		if (init_state == IOMMU_ACPI_FINISHED && amd_iommu_disabled) {
-			pr_info("AMD IOMMU disabled\n");
+		if (amd_iommu_disabled) {
 			init_state = IOMMU_CMDLINE_DISABLED;
 			ret = -EINVAL;
+		} else {
+			ret = early_amd_iommu_init();
+			init_state = ret ? IOMMU_INIT_ERROR : IOMMU_ACPI_FINISHED;
 		}
 		break;
 	case IOMMU_ACPI_FINISHED:


