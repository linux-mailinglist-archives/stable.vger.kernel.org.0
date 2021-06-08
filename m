Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D12D3A0035
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhFHSkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234017AbhFHSjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0F5E6141E;
        Tue,  8 Jun 2021 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177227;
        bh=D6ZSY6smbZX3GDr0IjSyAhQmxNP2xvB9l8kosypADrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKSSlgIQX0Cb2ZZzTO5maMAXBXFtpB9be4a6gQM0OKjBRYpvkfAhutoYom51OwL5p
         yE2nsfpc0A8LMxo5OaNp5aL0vQuIXHrwdH58y48YyLdGBkXLZP6dQSzxfEsrsVHj47
         y5ni0/L9JKSj9jtK6aD6k0q0aBJjwT0azyYKzYD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/58] vfio/pci: Fix error return code in vfio_ecap_init()
Date:   Tue,  8 Jun 2021 20:26:47 +0200
Message-Id: <20210608175932.488126941@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit d1ce2c79156d3baf0830990ab06d296477b93c26 ]

The error code returned from vfio_ext_cap_len() is stored in 'len', not
in 'ret'.

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Message-Id: <20210515020458.6771-1-thunder.leizhen@huawei.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a1a26465d224..86e917f1cc21 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1579,7 +1579,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 			if (len == 0xFF) {
 				len = vfio_ext_cap_len(vdev, ecap, epos);
 				if (len < 0)
-					return ret;
+					return len;
 			}
 		}
 
-- 
2.30.2



