Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC715C162
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgBMPW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgBMPW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:57 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455AE246A3;
        Thu, 13 Feb 2020 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607375;
        bh=AZy+x0Fk55noPNLyjgWXk9oE7vO+9pjKvSk7zRzEL5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1TfMKgz34+sB+TnL4jpEg7tyoAFjx5oqDyiiUJHcUM0d8E53U66N2RA5w0zw3ilr
         G+Iaa1sT5To/UHAs5/rPVryKF3yT6TSxl48PSDBDRXWdYYNAP8Li0MnXkmAFLzaHFc
         ra9rie5KRDzTPnV6kRsEehG6wHV9EsJ77rtPp9EM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 69/91] KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:20:26 -0800
Message-Id: <20200213151848.896341565@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

[ Upstream commit 14e32321f3606e4b0970200b6e5e47ee6f1e6410 ]

This fixes a Spectre-v1/L1TF vulnerability in picdev_write().
It replaces index computations based on the (attacked-controlled) port
number with constants through a minor refactoring.

Fixes: 85f455f7ddbe ("KVM: Add support for in-kernel PIC emulation")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/i8259.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index ce0f29e5d7c43..791850bfc9817 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -468,10 +468,14 @@ static int picdev_write(struct kvm_pic *s,
 	switch (addr) {
 	case 0x20:
 	case 0x21:
+		pic_lock(s);
+		pic_ioport_write(&s->pics[0], addr, data);
+		pic_unlock(s);
+		break;
 	case 0xa0:
 	case 0xa1:
 		pic_lock(s);
-		pic_ioport_write(&s->pics[addr >> 7], addr, data);
+		pic_ioport_write(&s->pics[1], addr, data);
 		pic_unlock(s);
 		break;
 	case 0x4d0:
-- 
2.20.1



