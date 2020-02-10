Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21815750D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgBJMiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729078AbgBJMiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:15 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9546B20842;
        Mon, 10 Feb 2020 12:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338293;
        bh=CSrHh6ckbplG7cDGcTH5GkDJu+ynBZmL5i67RFtgq/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hn+qoUs49/D/Xs1isYRdlT5rZagjvvNSquUfKKHxxq3rpDoR0hlN14hTTbqg3QygY
         F+R8K6RyBwpVi3QvVzKOpNBc73yG2sGv8KwDpEIxXOP+PQvNzXN5FtvoG80gL7PGkz
         0J54/D2ReEsl3J7S0WqTG0+avy2VBHT3ngx1+q9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 198/309] KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks
Date:   Mon, 10 Feb 2020 04:32:34 -0800
Message-Id: <20200210122425.578433763@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 14e32321f3606e4b0970200b6e5e47ee6f1e6410 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/i8259.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -460,10 +460,14 @@ static int picdev_write(struct kvm_pic *
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


