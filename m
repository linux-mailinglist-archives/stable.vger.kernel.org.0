Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963CBB85FB
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406888AbfISWWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406886AbfISWWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1024C20678;
        Thu, 19 Sep 2019 22:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931759;
        bh=wnITQ2KXJYh9SLVeKmbRzzeu15XPQTUn5t2r+rTvR54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlAIjgao2YgTtCu+UhSoKUy961Oza5xtjEkKbJcooYxgfM/sAZxU+iaZ23UQ7S3Im
         D0aNrfqak2F6xNeX4dzidqPH4r98aNstyMutJxEVTWRzIGaJPfW+Rm2dLhg+rABcfD
         WYf6fs1gDis4nDsYpja3SH1OcVmMzKExBQ5ltY2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4.4 29/56] x86/boot: Add missing bootparam that breaks boot on some platforms
Date:   Fri, 20 Sep 2019 00:04:10 +0200
Message-Id: <20190919214756.275682667@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Change

  a90118c445cc x86/boot: Save fields explicitly, zero out everything else

modified the way boot parameters were saved on x86.  When this was
backported, e820_table didn't exists, and that change was dropped.
Unfortunately, e820_table did exist, it was just named e820_map
in this kernel version.

This was breaking booting on a Supermicro Super Server/A2SDi-2C-HLN4F
with a Denverton CPU.  Adding e820_map to the saved boot params table
fixes the issue.

Cc: <stable@vger.kernel.org> # 4.9.x, 4.4.x
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bootparam_utils.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -71,6 +71,7 @@ static void sanitize_boot_params(struct
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
 			BOOT_PARAM_PRESERVE(hdr),
+			BOOT_PARAM_PRESERVE(e820_map),
 			BOOT_PARAM_PRESERVE(eddbuf),
 		};
 


