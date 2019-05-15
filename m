Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC61F37E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfEOLD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfEOLD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB72C20881;
        Wed, 15 May 2019 11:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918208;
        bh=sJY81SqPFx9uVWpwlWxULDpYpvZNuIz5WuqgmFvI8MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7246WlpTVg+56ciS+Ndi6RnaGLSOJDNW57JTb21zonqD2gcZKtz1wZjNhesagd72
         uaApk30H6b4Ms9tgBkGLlikH7jdgQVzlgwiN5lo7G3Zb2QXCMkQS2F3tGMul+7mPSH
         DLbUN777B1waY/zMEPJgjjUSQdB7uJw6s9u7TCCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 046/266] powerpc/64: Make stf barrier PPC_BOOK3S_64 specific.
Date:   Wed, 15 May 2019 12:52:33 +0200
Message-Id: <20190515090724.023961338@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diana Craciun <diana.craciun@nxp.com>

commit 6453b532f2c8856a80381e6b9a1f5ea2f12294df upstream.

NXP Book3E platforms are not vulnerable to speculative store
bypass, so make the mitigations PPC_BOOK3S_64 specific.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -177,6 +177,7 @@ ssize_t cpu_show_spectre_v2(struct devic
 	return s.len;
 }
 
+#ifdef CONFIG_PPC_BOOK3S_64
 /*
  * Store-forwarding barrier support.
  */
@@ -322,3 +323,4 @@ static __init int stf_barrier_debugfs_in
 }
 device_initcall(stf_barrier_debugfs_init);
 #endif /* CONFIG_DEBUG_FS */
+#endif /* CONFIG_PPC_BOOK3S_64 */


