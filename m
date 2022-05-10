Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD415218C5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbiEJNkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245132AbiEJNid (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358DF24641E;
        Tue, 10 May 2022 06:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5BD260C1C;
        Tue, 10 May 2022 13:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AB8C385C2;
        Tue, 10 May 2022 13:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189236;
        bh=+/EhKZa3yEyfTWZOBmz0ERD1LfPtR3Iv1x4ZFPnLAPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ql9zqslUmRXTKxP7M+0x7Dl2Xc0YxhMEKIyovckFY2yTH6oamVNy+9UTDbXKp0Iqz
         cAnpOb6/BATeE+0WNkiKwhnEtR82Yq64Fe9WZqWvF9MBaop+avDgce2s2EB/ubS8e1
         4YLeEFGTTERvpbUrfhSREhVlzxdkkxg2ExuPWFNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 55/70] smsc911x: allow using IRQ0
Date:   Tue, 10 May 2022 15:08:14 +0200
Message-Id: <20220510130734.476379981@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit 5ef9b803a4af0f5e42012176889b40bb2a978b18 upstream.

The AlphaProject AP-SH4A-3A/AP-SH4AD-0A SH boards use IRQ0 for their SMSC
LAN911x Ethernet chip, so the networking on them must have been broken by
commit 965b2aa78fbc ("net/smsc911x: fix irq resource allocation failure")
which filtered out 0 as well as the negative error codes -- it was kinda
correct at the time, as platform_get_irq() could return 0 on of_irq_get()
failure and on the actual 0 in an IRQ resource.  This issue was fixed by
me (back in 2016!), so we should be able to fix this driver to allow IRQ0
usage again...

When merging this to the stable kernels, make sure you also merge commit
e330b9a6bb35 ("platform: don't return 0 from platform_get_irq[_byname]()
on error") -- that's my fix to platform_get_irq() for the DT platforms...

Fixes: 965b2aa78fbc ("net/smsc911x: fix irq resource allocation failure")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/656036e4-6387-38df-b8a7-6ba683b16e63@omp.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/smsc/smsc911x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2422,7 +2422,7 @@ static int smsc911x_drv_probe(struct pla
 	if (irq == -EPROBE_DEFER) {
 		retval = -EPROBE_DEFER;
 		goto out_0;
-	} else if (irq <= 0) {
+	} else if (irq < 0) {
 		pr_warn("Could not allocate irq resource\n");
 		retval = -ENODEV;
 		goto out_0;


