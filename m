Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0731CAAD6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgEHMhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgEHMhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E5E424953;
        Fri,  8 May 2020 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941435;
        bh=GCQZRYNuZPMp57ZSTlZkuHsJuxHJNw2e2VjolFX+Zc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPDkvC0zet4SoFrJFLfMD76TZ4LS4HgeDI+CYUseQiiSAjqfBStBlVo6/nS+mK2Ii
         nesEijcGDcMz+H8LojYQTwlN1Q/rXoL3K6p9tWakiZDixxvNMzdgIep76esj0eBXMn
         fmsqYPIC1oc2I9PNJvACz5nuiZb2towMfVXaV0HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-mips@linux-mips.org, kernel-janitors@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 031/312] MIPS: RM7000: Double locking bug in rm7k_tc_disable()
Date:   Fri,  8 May 2020 14:30:22 +0200
Message-Id: <20200508123126.677472805@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 58a7e1c140f3ad61646bc0cd9a1f6a9cafc0b225 upstream.

We obviously intended to enable IRQs again at the end.

Fixes: 745aef5df1e2 ('MIPS: RM7000: Add support for tertiary cache')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13815/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/sc-rm7k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/mm/sc-rm7k.c
+++ b/arch/mips/mm/sc-rm7k.c
@@ -161,7 +161,7 @@ static void rm7k_tc_disable(void)
 	local_irq_save(flags);
 	blast_rm7k_tcache();
 	clear_c0_config(RM7K_CONF_TE);
-	local_irq_save(flags);
+	local_irq_restore(flags);
 }
 
 static void rm7k_sc_disable(void)


