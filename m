Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85115450E2A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhKOSNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240093AbhKOSFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34CC76326D;
        Mon, 15 Nov 2021 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998132;
        bh=d1W/Mm5qqz722Rug1BmUtJM4GClARRRIRgfA+Tjtgoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSEhmog2l2s3MiUwewegUN00xk5u6LTDcDvPFzSfOqXM6CRp05z0Ls1/OmUk9jLWs
         WKJ5Oh8j4pVSr/NxTMPuyqj32qyGBauZAGcmYRpSnx1j40yAFY0tX7CukmRdAur1tl
         MuCSmGawUFtzFT/o92oyWeHS2VKDJ7YLzAVWH9CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/575] KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm
Date:   Mon, 15 Nov 2021 18:01:21 +0100
Message-Id: <20211115165356.117773956@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 1e2aa46de526a5adafe580bca4c25856bb06f09e ]

When the system is heavily overcommitted, kvm_s390_pv_init_vm might
generate stall notifications.

Fix this by using uv_call_sched instead of just uv_call. This is ok because
we are not holding spinlocks.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210920132502.36111-4-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 74265304dd9cd..8228878872228 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -190,7 +190,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
 	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
 
-	cc = uv_call(0, (u64)&uvcb);
+	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
-- 
2.33.0



