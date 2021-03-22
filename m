Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752E734414F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhCVMcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhCVMbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1077461994;
        Mon, 22 Mar 2021 12:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416303;
        bh=Sx6D0JMxot2iQKtDArVYoWeYn06xBWSeB/JlDe45mtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLJOuYKz7QWX4TTQ6tT0CTCXGao5fu0TVc3LPwD3o4FA+oUVaPQ+yiBUCSAALITHP
         B2nsvsBUqKgg82FRtksdEF9cv3tVKAHOp6YMpCDAK3fByynw+5e8ZRUmhoFCFzCvZm
         BVYtw3WBt6eRUKtZdlWqKlxBAvzrvsylWYlvC5xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.11 055/120] iommu/tegra-smmu: Make tegra_smmu_probe_device() to handle all IOMMU phandles
Date:   Mon, 22 Mar 2021 13:27:18 +0100
Message-Id: <20210322121931.519757598@linuxfoundation.org>
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

From: Dmitry Osipenko <digetx@gmail.com>

commit 8dfd0fa6ecdc5e2099a57d485b7ce237abc6c7a0 upstream.

The tegra_smmu_probe_device() handles only the first IOMMU device-tree
phandle, skipping the rest. Devices like 3D module on Tegra30 have
multiple IOMMU phandles, one for each h/w block, and thus, only one
IOMMU phandle is added to fwspec for the 3D module, breaking GPU.
Previously this problem was masked by tegra_smmu_attach_dev() which
didn't use the fwspec, but parsed the DT by itself. The previous commit
to tegra-smmu driver partially reverted changes that caused problems for
T124 and now we have tegra_smmu_attach_dev() that uses the fwspec and
the old-buggy variant of tegra_smmu_probe_device() which skips secondary
IOMMUs.

Make tegra_smmu_probe_device() not to skip the secondary IOMMUs. This
fixes a partially attached IOMMU of the 3D module on Tegra30 and now GPU
works properly once again.

Fixes: 765a9d1d02b2 ("iommu/tegra-smmu: Fix mc errors on tegra124-nyan")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/20210312155439.18477-1-digetx@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/tegra-smmu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -849,12 +849,11 @@ static struct iommu_device *tegra_smmu_p
 		smmu = tegra_smmu_find(args.np);
 		if (smmu) {
 			err = tegra_smmu_configure(smmu, dev, &args);
-			of_node_put(args.np);
 
-			if (err < 0)
+			if (err < 0) {
+				of_node_put(args.np);
 				return ERR_PTR(err);
-
-			break;
+			}
 		}
 
 		of_node_put(args.np);


