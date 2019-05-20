Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0325223598
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391211AbfETMgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391078AbfETMgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:36:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A3D921479;
        Mon, 20 May 2019 12:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355765;
        bh=eHlJ0naPd6O/ffkhTMYGG0Jy55Ey/sfpHFfDtbeGUEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPPYmBC6c4/Lq5DVdDoGjhZdobMWaLf4VPLd0Eopam6p9tlL51nDoHT2GPT7lOpOi
         Pds86QePI92FOnZatwBUX4KGYAiM5CMlpYm0CrJwk+ZucLhjRqln0PthVAih6lsx0L
         ABQk1kGrxS8siyzv2MnYtkyQk3T00gBhrD2lbGDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.1 116/128] KVM: Fix the bitmap range to copy during clear dirty
Date:   Mon, 20 May 2019 14:15:03 +0200
Message-Id: <20190520115256.639022939@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 4ddc9204572c33f2eb91fbdb1d99d8078388b67d upstream.

kvm_dirty_bitmap_bytes() will return the size of the dirty bitmap of
the memslot rather than the size of bitmap passed over from the ioctl.
Here for KVM_CLEAR_DIRTY_LOG we should only copy exactly the size of
bitmap that covers kvm_clear_dirty_log.num_pages.

Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2a31b9db153530df4aa02dac8c32837bf5f47019
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1250,7 +1250,7 @@ int kvm_clear_dirty_log_protect(struct k
 	if (!dirty_bitmap)
 		return -ENOENT;
 
-	n = kvm_dirty_bitmap_bytes(memslot);
+	n = ALIGN(log->num_pages, BITS_PER_LONG) / 8;
 
 	if (log->first_page > memslot->npages ||
 	    log->num_pages > memslot->npages - log->first_page ||


