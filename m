Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867D143A2D0
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhJYTxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237208AbhJYTu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9969360F46;
        Mon, 25 Oct 2021 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190956;
        bh=AQVgWzJuv2QeHhwBAzg32g9tGzl8LLTWIRGnB7s5nCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0O/3uYbUz+vlQQWoh+qDbDCSFpCD4LgggLc2vn1Lp7XV62n2v/1TIg+EVkJ5zhnB
         Ckr8CUlGetTPN4YwS6O2gsWsuYIFgoyjQKgYyo0HdCJi9IMJHt0qz2lyLaZ1RxMyjH
         kuna+sf/FQxZT3pBIfSyuhsk94QoI/ZBFY+ev2gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 111/169] KVM: SEV-ES: reduce ghcb_sa_len to 32 bits
Date:   Mon, 25 Oct 2021 21:14:52 +0200
Message-Id: <20211025191032.097266232@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9f1ee7b169afbd10c3ad254220d1b37beb5798aa upstream.

The size of the GHCB scratch area is limited to 16 KiB (GHCB_SCRATCH_AREA_LIMIT),
so there is no need for it to be a u64.  This fixes a build error on 32-bit
systems:

i686-linux-gnu-ld: arch/x86/kvm/svm/sev.o: in function `sev_es_string_io:
sev.c:(.text+0x110f): undefined reference to `__udivdi3'

Cc: stable@vger.kernel.org
Fixes: 019057bd73d1 ("KVM: SEV-ES: fix length of string I/O")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -191,7 +191,7 @@ struct vcpu_svm {
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
-	u64 ghcb_sa_len;
+	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
 


