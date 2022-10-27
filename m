Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5827B60FEFE
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiJ0RKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiJ0RKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:10:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992AE73C0C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3930762401
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E9DC433C1;
        Thu, 27 Oct 2022 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890621;
        bh=5nHD4EdobDTekB7OeRn72V2zL9cMbr3p5Z/BAnBioJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZACp127xSrZE+E4qNSSkcOLArWdxOfS2UuCWzK3oa/CdCmWokfFrwlbwcYDPHQql
         UfDf0kgJe10Vt9M+4PV9GS4U/7wZDLnPW544gbqppn1/aSKo//hWvgh/KPayZYA6zY
         o4SlPMI9gptlycBENIbxvvAX6TsCJ82bRsjkdxes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Seth Jenkins <sethjenkins@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 5.4 53/53] mm: /proc/pid/smaps_rollup: fix no vmas null-deref
Date:   Thu, 27 Oct 2022 18:56:41 +0200
Message-Id: <20221027165051.926794456@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -884,7 +884,7 @@ static int show_smaps_rollup(struct seq_
 		last_vma_end = vma->vm_end;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");


