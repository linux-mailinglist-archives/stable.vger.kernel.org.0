Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD84A11327D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfLDSIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:08:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730941AbfLDSIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:08:40 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56AF20862;
        Wed,  4 Dec 2019 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482920;
        bh=nQybpkEgQGYlDZRpW33M8eWJcLoJzleNnd/FTE5dnzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7o86Fw/MgKz1abtPdwg/FDV8A4deapwn2+KwPCLedDEowQqgtPElvovNtgH7zCa5
         umFKjFMStZPD8uINhwY+3Tiq9mHJ/eDml6qLOmlqhs97IJ44tYhD+6qtqz6NimFUJk
         083BjZrT1iky91GXtGt3xpeW8wqtCCxagyx9tb1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+7857962b4d45e602b8ad@syzkaller.appspotmail.com
Subject: [PATCH 4.14 144/209] kvm: properly check debugfs dentry before using it
Date:   Wed,  4 Dec 2019 18:55:56 +0100
Message-Id: <20191204175333.233165534@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 8ed0579c12b2fe56a1fac2f712f58fc26c1dc49b ]

debugfs can now report an error code if something went wrong instead of
just NULL.  So if the return value is to be used as a "real" dentry, it
needs to be checked if it is an error before dereferencing it.

This is now happening because of ff9fb72bc077 ("debugfs: return error
values, not NULL").  syzbot has found a way to trigger multiple debugfs
files attempting to be created, which fails, and then the error code
gets passed to dentry_path_raw() which obviously does not like it.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Reported-and-tested-by: syzbot+7857962b4d45e602b8ad@syzkaller.appspotmail.com
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cdaacdf7bc877..deff4b3eb9722 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3989,7 +3989,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (kvm->debugfs_dentry) {
+	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL);
 
 		if (p) {
-- 
2.20.1



