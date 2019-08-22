Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A799D1C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405016AbfHVRjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404131AbfHVRYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:14 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4094C2341C;
        Thu, 22 Aug 2019 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494654;
        bh=+VL99LgBXxx3VNYEmnTH+rsjkn7PIqtMJpOF/8r6jG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l11dggkE8dQfx7dJYMlE/UUFw+a1d5/YbMbE2BO7gKTVytcD44wmZqsb72vODvY+i
         ReRB9zT7pDg3MhZSOX9A7TuO2ToJNiqySmyFjuRV15Xbc8sjrOiF6E3W90gE6hswhM
         j+77rSLitovqj4EsYR0uBs0hjrhB/yG0fd+wu+DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.9 095/103] iommu/amd: Move iommu_init_pci() to .init section
Date:   Thu, 22 Aug 2019 10:19:23 -0700
Message-Id: <20190822171733.007625452@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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
@@ -1534,7 +1534,7 @@ static const struct attribute_group *amd
 	NULL,
 };
 
-static int iommu_init_pci(struct amd_iommu *iommu)
+static int __init iommu_init_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
 	u32 range, misc, low, high;


