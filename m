Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382F099C04
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733285AbfHVRa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404626AbfHVR0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:09 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2EF32064A;
        Thu, 22 Aug 2019 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494768;
        bh=Q94eA7juBZ1wPh7HFqVy/uB0bkDoo3w9xL16ej9JAEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMcmtFtTTwc5M1PVig+ZmrMn08f0quu6Bpls345uqw/br1cq5TNVBTL40Kb2AB1I0
         WhJmMKj7hytQ9Z9fZbRmkfRwv6pApnAf+YW/mU+yJZPPLzjnf54Ka+DPxW6gJjF8Pz
         7ed1sayjyNjV3uiibx2QGjzylSypzxwzOPNJtdB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 72/85] iommu/amd: Move iommu_init_pci() to .init section
Date:   Thu, 22 Aug 2019 10:19:45 -0700
Message-Id: <20190822171734.281810393@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 24d2c521749d8547765b555b7a85cca179bb2275 upstream.

The function is only called from another __init function, so
it should be moved to .init too.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1710,7 +1710,7 @@ static const struct attribute_group *amd
 	NULL,
 };
 
-static int iommu_init_pci(struct amd_iommu *iommu)
+static int __init iommu_init_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
 	u32 range, misc, low, high;


