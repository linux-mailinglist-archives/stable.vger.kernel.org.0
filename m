Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E1319B2D1
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbgDAQrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389723AbgDAQrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:47:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E652B206E9;
        Wed,  1 Apr 2020 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759629;
        bh=JlDBYbueVX9HaVgltnLZvM2z5YurHeXCEuSgcZCEEo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSQQo2D78EaxdV/vS1drZWM4tLPJS3BePf0CKsz84TXOePOKHMZNNTENRH0Y4jaCW
         kXbAlEl2TB9x87uRdxS3vKLLsB3sYVQ9SQg8ggh+5TPzsRiyDhBQXRK2DhlGPi1xfk
         aLixAqFJUmmIFXrmRY8oW2vFJ92KpHwmwpFWPuxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 4.14 140/148] bpf: Explicitly memset some bpf info structures declared on the stack
Date:   Wed,  1 Apr 2020 18:18:52 +0200
Message-Id: <20200401161605.620622049@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5c6f25887963f15492b604dd25cb149c501bbabf upstream.

Trying to initialize a structure with "= {};" will not always clean out
all padding locations in a structure. So be explicit and call memset to
initialize everything for a number of bpf information structures that
are then copied from userspace, sometimes from smaller memory locations
than the size of the structure.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200320162258.GA794295@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/syscall.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1364,7 +1364,7 @@ static int bpf_prog_get_info_by_fd(struc
 				   union bpf_attr __user *uattr)
 {
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_prog_info info = {};
+	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
 	char __user *uinsns;
 	u32 ulen;
@@ -1375,6 +1375,7 @@ static int bpf_prog_get_info_by_fd(struc
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
+	memset(&info, 0, sizeof(info));
 	if (copy_from_user(&info, uinfo, info_len))
 		return -EFAULT;
 
@@ -1420,7 +1421,7 @@ static int bpf_map_get_info_by_fd(struct
 				  union bpf_attr __user *uattr)
 {
 	struct bpf_map_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_map_info info = {};
+	struct bpf_map_info info;
 	u32 info_len = attr->info.info_len;
 	int err;
 
@@ -1429,6 +1430,7 @@ static int bpf_map_get_info_by_fd(struct
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
+	memset(&info, 0, sizeof(info));
 	info.type = map->map_type;
 	info.id = map->id;
 	info.key_size = map->key_size;


