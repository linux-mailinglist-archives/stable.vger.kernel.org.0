Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3624E171D21
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389287AbgB0OSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389813AbgB0OSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 872AE20801;
        Thu, 27 Feb 2020 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813085;
        bh=z19uYR+QfCZ8E4oYV9c3VMN4H6XEwgmRfaD1iFIPAIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzFnECZmFZdUYW8BLHbKabPxKSd+Hn8OYR+nD91nAkHgxpJmzSs4VNqaI3okD/0tY
         1TogXfKPK+cfpq4JvxFFOWUvhnzx7dgHw2/yskwGMGn+QZQQSFXVho57FIm2Qcznfh
         nw2eZokgOMf7WBVbj268kXA4wwBOFCPi8CmG0gn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Krude <johannes@krude.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.5 131/150] bpf, offload: Replace bitwise AND by logical AND in bpf_prog_offload_info_fill
Date:   Thu, 27 Feb 2020 14:37:48 +0100
Message-Id: <20200227132251.857001787@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Krude <johannes@krude.de>

commit e20d3a055a457a10a4c748ce5b7c2ed3173a1324 upstream.

This if guards whether user-space wants a copy of the offload-jited
bytecode and whether this bytecode exists. By erroneously doing a bitwise
AND instead of a logical AND on user- and kernel-space buffer-size can lead
to no data being copied to user-space especially when user-space size is a
power of two and bigger then the kernel-space buffer.

Fixes: fcfb126defda ("bpf: add new jited info fields in bpf_dev_offload and bpf_prog_info")
Signed-off-by: Johannes Krude <johannes@krude.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/bpf/20200212193227.GA3769@phlox.h.transitiv.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -321,7 +321,7 @@ int bpf_prog_offload_info_fill(struct bp
 
 	ulen = info->jited_prog_len;
 	info->jited_prog_len = aux->offload->jited_len;
-	if (info->jited_prog_len & ulen) {
+	if (info->jited_prog_len && ulen) {
 		uinsns = u64_to_user_ptr(info->jited_prog_insns);
 		ulen = min_t(u32, info->jited_prog_len, ulen);
 		if (copy_to_user(uinsns, aux->offload->jited_image, ulen)) {


