Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABFC37C9FA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhELQXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239912AbhELQQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 460BA61D6A;
        Wed, 12 May 2021 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834170;
        bh=CV5eJs6yUa5yct1u4+9rpQcqM8A/SP7n9ICzvNqK2qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWytbEdeMnUKf8bCfAdh9dC9Zcq3OkGXI62E+BLDkg8aKnFzzyx1QIqwqtW3sowWr
         8HQuIcHnbQ7qJuxFHvfWljQE/Lh0vAp4t0c6ShvfmbOZX9RMdsqBeFzQApWMBrQNur
         2HCVE7EFl81nFoCz9uHiIGzDqNqF/Mzb4rVjBTYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 435/601] KVM: arm64: Fix error return code in init_hyp_mode()
Date:   Wed, 12 May 2021 16:48:32 +0200
Message-Id: <20210512144842.167123979@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index b25b4c19feeb..64258d26ba24 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1809,8 +1809,10 @@ static int init_hyp_mode(void)
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



