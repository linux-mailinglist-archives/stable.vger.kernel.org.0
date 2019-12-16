Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B8712164E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbfLPSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731057AbfLPSPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B97820717;
        Mon, 16 Dec 2019 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520105;
        bh=PE1gd6chq3u1lu+cX2GWnYFFwUK7giUUhwiAe5+2BQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orV7rlRJopM4vjOEC4g+o10GfO9NmkHRn8ZnAdnWIJao8APop5mAMw1PH5LPoNOpN
         CzbayVVacZfUWoLyzQL0Aby5pcV50fmbcZ67OkOjTjEJh+YGQweGBdEP1MDvlYuoKf
         jXbWPRaFJNJli/eHpvx2L4Ai+xJaH4yu9DgaWahE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 019/177] binder: fix incorrect calculation for num_valid
Date:   Mon, 16 Dec 2019 18:47:55 +0100
Message-Id: <20191216174816.834777313@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
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
@@ -3314,7 +3314,7 @@ static void binder_transaction(struct bi
 			binder_size_t parent_offset;
 			struct binder_fd_array_object *fda =
 				to_binder_fd_array_object(hdr);
-			size_t num_valid = (buffer_offset - off_start_offset) *
+			size_t num_valid = (buffer_offset - off_start_offset) /
 						sizeof(binder_size_t);
 			struct binder_buffer_object *parent =
 				binder_validate_ptr(target_proc, t->buffer,
@@ -3388,7 +3388,7 @@ static void binder_transaction(struct bi
 				t->buffer->user_data + sg_buf_offset;
 			sg_buf_offset += ALIGN(bp->length, sizeof(u64));
 
-			num_valid = (buffer_offset - off_start_offset) *
+			num_valid = (buffer_offset - off_start_offset) /
 					sizeof(binder_size_t);
 			ret = binder_fixup_parent(t, thread, bp,
 						  off_start_offset,


