Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30D8521A35
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244072AbiEJNyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243724AbiEJNww (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454A4663FD;
        Tue, 10 May 2022 06:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E437BB81DA8;
        Tue, 10 May 2022 13:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6BBC385C2;
        Tue, 10 May 2022 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189836;
        bh=WTnl3+B6yRLPj0eRn2sUYYRUVNpckkYKXc79sNWkQus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTgooY4m3Ik/m0UMCHM/36ffJDtHZG9jdlu8Knqqpqp7JegKHBO3A89O09uUUUKhq
         WpWK+iX4JNkZfGOCs0l7jLKrnWi4E71nupoL7we+LM1zaCwDMG1woo12ELlMO1iA/o
         12XjPWTi5NiRBEg0+4E/SRsIplZVko6U8/gHE4NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.17 007/140] parisc: Merge model and model name into one line in /proc/cpuinfo
Date:   Tue, 10 May 2022 15:06:37 +0200
Message-Id: <20220510130741.817380046@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
@@ -418,8 +418,7 @@ show_cpuinfo (struct seq_file *m, void *
 		}
 		seq_printf(m, " (0x%02lx)\n", boot_cpu_data.pdc.capabilities);
 
-		seq_printf(m, "model\t\t: %s\n"
-				"model name\t: %s\n",
+		seq_printf(m, "model\t\t: %s - %s\n",
 				 boot_cpu_data.pdc.sys_model_name,
 				 cpuinfo->dev ?
 				 cpuinfo->dev->name : "Unknown");


