Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B36E52189C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbiEJNj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbiEJNgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603CC2D9ED1;
        Tue, 10 May 2022 06:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EAFD617B0;
        Tue, 10 May 2022 13:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9ADC385C2;
        Tue, 10 May 2022 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189122;
        bh=NZhQevZcqdnSmjHIeiRhCKNQNiuW3X6d3Bp6k7e4zGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHYswWnubzQuT+DmyWFzjGCWwXqiF2yhCRt60ufJDJQovHwVCtnZqhbB0j5BblrVn
         kc5BUH3wTi2tUnobGT3UPaOC1UHFhb9Dgt080p1RsPX5pPtFsKaKrwtyqn/Ud3Vb9Y
         pBrnu2AsBKuXhN3JTOyxjqRzIXR8SIzRNQMXQaRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 02/70] parisc: Merge model and model name into one line in /proc/cpuinfo
Date:   Tue, 10 May 2022 15:07:21 +0200
Message-Id: <20220510130732.935799125@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 5b89966bc96a06f6ad65f64ae4b0461918fcc9d3 upstream.

The Linux tool "lscpu" shows the double amount of CPUs if we have
"model" and "model name" in two different lines in /proc/cpuinfo.
This change combines the model and the model name into one line.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/processor.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -419,8 +419,7 @@ show_cpuinfo (struct seq_file *m, void *
 		}
 		seq_printf(m, " (0x%02lx)\n", boot_cpu_data.pdc.capabilities);
 
-		seq_printf(m, "model\t\t: %s\n"
-				"model name\t: %s\n",
+		seq_printf(m, "model\t\t: %s - %s\n",
 				 boot_cpu_data.pdc.sys_model_name,
 				 cpuinfo->dev ?
 				 cpuinfo->dev->name : "Unknown");


