Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3992F1532
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbhAKNgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731962AbhAKNNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9ABB229CA;
        Mon, 11 Jan 2021 13:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370779;
        bh=NMxXDtc8MfsJkBGWXGqageMRuBuHhgOkitW4IGQVKo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQoXbmo1IBKvgJLIKELPo99kEZ4MFU/h2CU7zVTESAM12fvwRNmlyeKZt5n8Y4eG8
         7U4v/3Zmpfii88cEn863n2NMC0jNDlRp6EDpe+refojxF6wYuaJHHLUYtgnnPK8Km6
         +dnZXVKJrBFXbL+bekIGdEsU+jjb+rymI4ozMAx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 92/92] KVM: x86: fix shift out of bounds reported by UBSAN
Date:   Mon, 11 Jan 2021 14:02:36 +0100
Message-Id: <20210111130043.591744897@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 2f80d502d627f30257ba7e3655e71c373b7d1a5a upstream.

Since we know that e >= s, we can reassociate the left shift,
changing the shifted number from 1 to 2 in exchange for
decreasing the right hand side by 1.

Reported-by: syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -48,7 +48,7 @@ static inline u64 rsvd_bits(int s, int e
 	if (e < s)
 		return 0;
 
-	return ((1ULL << (e - s + 1)) - 1) << s;
+	return ((2ULL << (e - s)) - 1) << s;
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask);


