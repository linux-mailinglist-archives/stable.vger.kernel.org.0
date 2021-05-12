Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC38037CDCE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhELQ6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244198AbhELQmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD606199D;
        Wed, 12 May 2021 16:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835890;
        bh=ZkNnhDdYRKgPo70GAuUss3s4JuiLHL0OX7tSWQUt6ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi6ssDXT9fqRn1yx/6qU150ZVLxkNUo/KMOtx/kkgP7eSGPyj9FtcjeO8wTAwJ6dT
         GfryfH5rtYs4Ec7EP2dIQj7VvjEx5W0Kng0Nse6SAiObXmwwer2xsMwQQmrVwQ2QWl
         yh1WhrGAAOv+nI4sgPJNyOzP5YNDRZLLy0ynk5OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 490/677] KVM: arm64: Fix error return code in init_hyp_mode()
Date:   Wed, 12 May 2021 16:48:56 +0200
Message-Id: <20210512144853.664086829@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 52b9e265d22bccc5843e167da76ab119874e2883 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: eeeee7193df0 ("KVM: arm64: Bootstrap PSCI SMC handler in nVHE EL2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210406121759.5407-1-wangwensheng4@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..85261015ce5d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1808,8 +1808,10 @@ static int init_hyp_mode(void)
 	if (is_protected_kvm_enabled()) {
 		init_cpu_logical_map();
 
-		if (!init_psci_relay())
+		if (!init_psci_relay()) {
+			err = -ENODEV;
 			goto out_err;
+		}
 	}
 
 	return 0;
-- 
2.30.2



