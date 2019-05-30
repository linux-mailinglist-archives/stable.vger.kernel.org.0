Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF2A2EEFF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfE3Dvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbfE3DTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF97248C3;
        Thu, 30 May 2019 03:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186384;
        bh=l9B/OIDn8cuAVE8HO0aG3+J5d3MKu0EY/omgxsB3MUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DX+sfQTjKtQxzoAr0eZRDCGnj/8vhP/Z+qZ/pJNQP8xt0Z3Ud8bFT5O9fXOhtXIDa
         TQFR/y0Asl3RUh2s9A0GvYl4vFM9dcViySqnHU9Y+n/s8zkT9P4S3uWBQ6a0QJxv3S
         +K8BrLiNJcgsVBASGXcHBc4w9e/9wYRKzxqvXQzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/193] arm64: cpu_ops: fix a leaked reference by adding missing of_node_put
Date:   Wed, 29 May 2019 20:06:45 -0700
Message-Id: <20190530030509.250581004@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 92606ec9285fb84cd9b5943df23f07d741384bfc ]

The call to of_get_next_child returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
  ./arch/arm64/kernel/cpu_ops.c:102:1-7: ERROR: missing of_node_put;
  acquired a node pointer with refcount incremented on line 69, but
  without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu_ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
index d16978213c5b3..e2a9d04d05175 100644
--- a/arch/arm64/kernel/cpu_ops.c
+++ b/arch/arm64/kernel/cpu_ops.c
@@ -85,6 +85,7 @@ static const char *__init cpu_read_enable_method(int cpu)
 				pr_err("%pOF: missing enable-method property\n",
 					dn);
 		}
+		of_node_put(dn);
 	} else {
 		enable_method = acpi_get_enable_method(cpu);
 		if (!enable_method) {
-- 
2.20.1



