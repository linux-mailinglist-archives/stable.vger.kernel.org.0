Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379C2FF19E
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfKPPsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:48:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729888AbfKPPsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:00 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D04A208E3;
        Sat, 16 Nov 2019 15:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919279;
        bh=8YhL0ze8eWMLOFfOXvqE7tZ92Hf36MAGwjzaFKJo2Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMX5LBvsi+PVK++ytpnfqRB9AaW/0xts/2ZZNh3D8ISyQiDMEi9pq1UvwBCvhZ41X
         5wgpY4ljKABsKA7UizDge+hzia0bKGk297ncc5JBZStTANCkdn6WNvwRvXWXFCKS82
         wM7kBzuDLnuV7IVN0bGuqvBYja7XQHKWVX8APH04=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 030/150] KVM/x86: Fix invvpid and invept register operand size in 64-bit mode
Date:   Sat, 16 Nov 2019 10:45:28 -0500
Message-Id: <20191116154729.9573-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 5ebb272b2ea7e02911a03a893f8d922d49f9bb4a ]

Register operand size of invvpid and invept instruction in 64-bit mode
has always 64 bits. Adjust inline function argument type to reflect
correct size.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ae34b482e9109..0bd5f8f4d6ebd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1602,7 +1602,7 @@ static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 	return -1;
 }
 
-static inline void __invvpid(int ext, u16 vpid, gva_t gva)
+static inline void __invvpid(unsigned long ext, u16 vpid, gva_t gva)
 {
     struct {
 	u64 vpid : 16;
@@ -1616,7 +1616,7 @@ static inline void __invvpid(int ext, u16 vpid, gva_t gva)
 		  : : "a"(&operand), "c"(ext) : "cc", "memory");
 }
 
-static inline void __invept(int ext, u64 eptp, gpa_t gpa)
+static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
 {
 	struct {
 		u64 eptp, gpa;
-- 
2.20.1

