Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C05469F23
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391450AbhLFPpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390538AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D448C0698D2;
        Mon,  6 Dec 2021 07:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06A16B81116;
        Mon,  6 Dec 2021 15:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D031C34901;
        Mon,  6 Dec 2021 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804478;
        bh=HEvcC0/JRzeUJxcjiT3CPSkPRecO41OEfqZVvML1KJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVSGi445czWihkOJor56hAn8utg4+1tYmvewriVUyen/1dbDV3WKKK7I6kkYbROAb
         xXvx2TLvulS+lrR3cGxVT022mvsVfD6lS44Zl4zLX3V3fQTT3yDcCNE9M3+A4kIR1X
         SmW7E2LJMQUWgZGD0NIUH1QZEKxEFd7wA6UpBR4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/207] KVM: SEV: initialize regions_list of a mirror VM
Date:   Mon,  6 Dec 2021 15:56:55 +0100
Message-Id: <20211206145615.848113291@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 2b347a387811cb4aa7bcdb96e9203c5019a6fb41 ]

This was broken before the introduction of KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
but technically harmless because the region list was unused for a mirror
VM.  However, it is untidy and it now causes a NULL pointer access when
attempting to move the encryption context of a mirror VM.

Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
Message-Id: <20211123005036.2954379-7-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ff19ce0780fea..ca0effb79eab9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1805,6 +1805,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->fd = source_sev.fd;
 	mirror_sev->es_active = source_sev.es_active;
 	mirror_sev->handle = source_sev.handle;
+	INIT_LIST_HEAD(&mirror_sev->regions_list);
 	/*
 	 * Do not copy ap_jump_table. Since the mirror does not share the same
 	 * KVM contexts as the original, and they may have different
-- 
2.33.0



