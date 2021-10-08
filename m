Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173EF4269BE
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbhJHLky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243281AbhJHLjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC644615E1;
        Fri,  8 Oct 2021 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692808;
        bh=hvCMlG5eM/ZE0hb2vtmGAqI3mUGuN8/wMAQbDTHQwR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q45yIglvoXTS5vl/v7Tf0gWRJI9NOVKze9xg6EmE8QTGMijW113wpZPEczd0Ufz/q
         8YtQ8JcQWifS+C6M3uIgyUkaaRYC8z7XEOjEqmBV1Y3Q/vdF4ojBSeHfAcKXczAOyS
         c6FDSx0858Rown1pyvf1ZIIb67CBM8pQkZIWclGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 40/48] selftests: KVM: Align SMCCC call with the spec in steal_time
Date:   Fri,  8 Oct 2021 13:28:16 +0200
Message-Id: <20211008112721.374609144@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit 01f91acb55be7aac3950b89c458bcea9ef6e4f49 ]

The SMC64 calling convention passes a function identifier in w0 and its
parameters in x1-x17. Given this, there are two deviations in the
SMC64 call performed by the steal_time test: the function identifier is
assigned to a 64 bit register and the parameter is only 32 bits wide.

Align the call with the SMCCC by using a 32 bit register to handle the
function identifier and increasing the parameter width to 64 bits.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Message-Id: <20210921171121.2148982-3-oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/steal_time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 2172d65b85e4..62f2eb9ee3d5 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -116,12 +116,12 @@ struct st_time {
 	uint64_t st_time;
 };
 
-static int64_t smccc(uint32_t func, uint32_t arg)
+static int64_t smccc(uint32_t func, uint64_t arg)
 {
 	unsigned long ret;
 
 	asm volatile(
-		"mov	x0, %1\n"
+		"mov	w0, %w1\n"
 		"mov	x1, %2\n"
 		"hvc	#0\n"
 		"mov	%0, x0\n"
-- 
2.33.0



