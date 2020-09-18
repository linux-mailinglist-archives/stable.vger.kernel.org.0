Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C37526EB0D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgIRCCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgIRCCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E8923447;
        Fri, 18 Sep 2020 02:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394561;
        bh=aq1/5r2rp+WYg/sjQ6/chbTXBc+6EZ0FkQdPv+m7yps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZ+KVvmKA9ceJqYM3lDLF1jhOSD9voeQJAwn8805WOZ0GekFdFOxRrFfBfRaD5SLA
         ODN1lm+RwtxoEGhoTKtVHUsTGpkwlB4W2JfngPF1lt/+PG2JkkcFhXtl9vYRGYhB8A
         /RpqbTTRTvJ1hSmKJjMswzff+oYhKAII5noa/X4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 074/330] KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()
Date:   Thu, 17 Sep 2020 21:56:54 -0400
Message-Id: <20200918020110.2063155-74-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 0bda9498dd45280e334bfe88b815ebf519602cc3 ]

In kvm_vgic_dist_init() called from kvm_vgic_map_resources(), if
dist->vgic_model is invalid, dist->spis will be freed without set
dist->spis = NULL. And in vgicv2 resources clean up path,
__kvm_vgic_destroy() will be called to free allocated resources.
And dist->spis will be freed again in clean up chain because we
forget to set dist->spis = NULL in kvm_vgic_dist_init() failed
path. So double free would happen.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/1574923128-19956-1-git-send-email-linmiaohe@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 6f50c429196de..6d85c6d894c39 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 			break;
 		default:
 			kfree(dist->spis);
+			dist->spis = NULL;
 			return -EINVAL;
 		}
 	}
-- 
2.25.1

