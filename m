Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690C65216B0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiEJNRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242498AbiEJNQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE643496B3;
        Tue, 10 May 2022 06:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93CFBCE1EE2;
        Tue, 10 May 2022 13:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CD6C385A6;
        Tue, 10 May 2022 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188350;
        bh=NHaV4yuE/2PD3w4mbg06eoAygsYUC7lzoD4CfDzjT74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae/lXk5JUOyy15WErMvHuUpai5EpPoVqqYaSKU45Q8lWvcUVUN08TOSEatG/k3oZM
         pXlLQX2JVUQvGxSNKUTykUECCzuaHvPZVStaRq7dzDzmlIENYIlTQFPg9Xl9IFzHX+
         TPiWsHWc5TuyFJNPpnNLsSrk+/szQTQEMnT09Gmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 44/66] parisc: Merge model and model name into one line in /proc/cpuinfo
Date:   Tue, 10 May 2022 15:07:34 +0200
Message-Id: <20220510130731.059057471@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
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
@@ -390,8 +390,7 @@ show_cpuinfo (struct seq_file *m, void *
 		}
 		seq_printf(m, " (0x%02lx)\n", boot_cpu_data.pdc.capabilities);
 
-		seq_printf(m, "model\t\t: %s\n"
-				"model name\t: %s\n",
+		seq_printf(m, "model\t\t: %s - %s\n",
 				 boot_cpu_data.pdc.sys_model_name,
 				 cpuinfo->dev ?
 				 cpuinfo->dev->name : "Unknown");


