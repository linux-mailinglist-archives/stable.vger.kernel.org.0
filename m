Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645E1615A53
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiKBD3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiKBD2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:28:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2941CFF5
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEB81B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE34C433C1;
        Wed,  2 Nov 2022 03:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359732;
        bh=rWhU/SqasFIJoRXBvcjIy/bDPWGDBqbBtACBiwQelic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8RPaZrdBDL9ZM3lMoSL0G9DtgsN3CGVgDqNozZn3jCxilZ9XPZw8cB33oY1iYDbF
         HfFNZYyqWsGHHH007HdvAmh/B+q9UPtLN3rGxWEqyEa9YJIaQUxfw4w5XJEEN9nWxU
         jdbxtsnqVLouIdsQxZXfZrJjSat0T+UacINre4VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Seth Jenkins <sethjenkins@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 4.19 25/78] mm: /proc/pid/smaps_rollup: fix no vmas null-deref
Date:   Wed,  2 Nov 2022 03:34:10 +0100
Message-Id: <20221102022053.728324426@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Jenkins <sethjenkins@google.com>

Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
seq_file") introduced a null-deref if there are no vma's in the task in
show_smaps_rollup.

Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -843,7 +843,7 @@ static int show_smaps_rollup(struct seq_
 		last_vma_end = vma->vm_end;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");


