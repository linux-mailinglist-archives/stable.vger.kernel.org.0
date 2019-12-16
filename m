Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2312173B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbfLPSHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbfLPSHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C23A20CC7;
        Mon, 16 Dec 2019 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519650;
        bh=NrwJ/T0J+hwOEUD8tFTp6mb6eQcRRMoPmExsk3iDw3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYSDKm54YJsuSf42Uw4RSSm4xIHUcu+RRktA+CxLn5RPHrZvSzfFnW53KNHGAMEsA
         G3hG6N1Kd9sFYFKv6l66xG+YFlCbe9aA0SYAgYnIFqCU00r1oZJF9WrWOzuCMILWrf
         BOyF9C+Zmj77m11N2C/X3olJnYdEhDpHoN9e5ojk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.3 013/180] binder: fix incorrect calculation for num_valid
Date:   Mon, 16 Dec 2019 18:47:33 +0100
Message-Id: <20191216174808.729939627@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit 16981742717b04644a41052570fb502682a315d2 upstream.

For BINDER_TYPE_PTR and BINDER_TYPE_FDA transactions, the
num_valid local was calculated incorrectly causing the
range check in binder_validate_ptr() to miss out-of-bounds
offsets.

Fixes: bde4a19fc04f ("binder: use userspace pointer as base of buffer space")
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213202531.55010-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3332,7 +3332,7 @@ static void binder_transaction(struct bi
 			binder_size_t parent_offset;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
-			size_t num_valid = (buffer_offset - off_start_offset) *
+			size_t num_valid = (buffer_offset - off_start_offset) /
 						sizeof(binder_size_t);
 			struct binder_buffer_object *parent =
 				binder_validate_ptr(target_proc, t->buffer,
@@ -3406,7 +3406,7 @@ static void binder_transaction(struct bi
 				t->buffer->user_data + sg_buf_offset;
 			sg_buf_offset += ALIGN(bp->length, sizeof(u64));
 
-			num_valid = (buffer_offset - off_start_offset) *
+			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
 			ret = binder_fixup_parent(t, thread, bp,
 						  off_start_offset,


