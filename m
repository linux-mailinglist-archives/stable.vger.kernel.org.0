Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A4F4524E1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344761AbhKPBqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241251AbhKOSUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:20:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF4D5632B3;
        Mon, 15 Nov 2021 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998742;
        bh=yKn0b/xP2FvHRGArpVNKANQ3Xz0stDh3z7oelSZtWuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEOszVMJ+QqVTxsDCGJpvaQvum6tyVw1SqLp3ml4eymuvCYMvMRIhkmfFyuW85yPZ
         WlTqCS+P2YiXt5i/OJOSZDoQfhUvnYawiue5TMCwtuYxrZwrv8UeEOzHUeQpcPWJ0I
         mFO3zclrTOc7EPSBBKB3JIRjqEYEj3dLWS2ZQUlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 045/849] ALSA: PCM: Fix NULL dereference at mmap checks
Date:   Mon, 15 Nov 2021 17:52:08 +0100
Message-Id: <20211115165421.526116000@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 8e537d5dec34cac746dd6abf6a83e5de3aa471fc upstream.

The recent refactoring of mmap handling caused Oops on some devices
that don't use the standard memory allocations.  This patch addresses
it by allowing snd_dma_buffer_mmap() helper to receive the NULL
pointer dmab argument (and return an error appropriately).

Fixes: a202bd1ad86d ("ALSA: core: Move mmap handler into memalloc ops")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211107163911.13534-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -135,8 +135,11 @@ EXPORT_SYMBOL(snd_dma_free_pages);
 int snd_dma_buffer_mmap(struct snd_dma_buffer *dmab,
 			struct vm_area_struct *area)
 {
-	const struct snd_malloc_ops *ops = snd_dma_get_ops(dmab);
+	const struct snd_malloc_ops *ops;
 
+	if (!dmab)
+		return -ENOENT;
+	ops = snd_dma_get_ops(dmab);
 	if (ops && ops->mmap)
 		return ops->mmap(dmab, area);
 	else


