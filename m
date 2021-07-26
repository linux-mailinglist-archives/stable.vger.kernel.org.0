Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7419E3D5F84
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhGZPSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236899AbhGZPPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCE6D61029;
        Mon, 26 Jul 2021 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314877;
        bh=AGq2x0t0KxaJNErco3NfpF3Q+7Djdn+ezKGvOUM6QRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4CCW+OvtakoDo2bYYqVMws2j+mrk6M92ttpmbWMtJjHqyzxPj/Fhj4OHYGWN+5B8
         AU9bLMpfcqpibK0WrPdkKvxeYG73mNLh/VLyVAw0oa/9K23gATVCZ/ejN6Gp+QObLj
         y2wjut6KEGiQaa0t6M/UFHGVTZNPVupLfF+IyvAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Qiang Liu <cyruscyliu@gmail.com>,
        iLifetruth <yixiaonn@gmail.com>
Subject: [PATCH 4.19 109/120] nds32: fix up stack guard gap
Date:   Mon, 26 Jul 2021 17:39:21 +0200
Message-Id: <20210726153835.956278062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c453db6cd96418c79702eaf38259002755ab23ff upstream.

Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
up all architectures to deal with the stack guard gap.  But when nds32
was added to the tree, it forgot to do the same thing.

Resolve this by properly fixing up the nsd32's version of
arch_get_unmapped_area()

Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qiang Liu <cyruscyliu@gmail.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: iLifetruth <yixiaonn@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Link: https://lore.kernel.org/r/20210629104024.2293615-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nds32/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/nds32/mm/mmap.c
+++ b/arch/nds32/mm/mmap.c
@@ -59,7 +59,7 @@ arch_get_unmapped_area(struct file *filp
 
 		vma = find_vma(mm, addr);
 		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vma->vm_start))
+		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
 


