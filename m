Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0AC171F1B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbgB0OBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733011AbgB0OBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF2D20801;
        Thu, 27 Feb 2020 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812113;
        bh=fIQ9dRT5falEOKAiEhOmoWhkW76BUdeoKlh3hMghr8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCc59oIcl+5Nd5zfQCfSH32ksUdIGJr3XB5UqvLe5j5CLGK8VpKKWDm9XIljADc16
         AYrRsAnjApw6s9gUcJ9o3Uai1jvEsSYqec4Zv7cA201rp3NTLEz+M+zFjID6tZOEGq
         NQiPRtaHakCG3NpTR4btRQbtYfAwzPPg5NuWL5eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.14 226/237] staging: rtl8723bs: fix copy of overlapping memory
Date:   Thu, 27 Feb 2020 14:37:20 +0100
Message-Id: <20200227132312.756569432@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 8ae9a588ca35eb9c32dc03299c5e1f4a1e9a9617 upstream.

Currently the rtw_sprintf prints the contents of thread_name
onto thread_name and this can lead to a potential copy of a
string over itself. Avoid this by printing the literal string RTWHALXT
instread of the contents of thread_name.

Addresses-Coverity: ("copy of overlapping memory")
Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200126220549.9849-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
+++ b/drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
@@ -486,14 +486,13 @@ int rtl8723bs_xmit_thread(void *context)
 	s32 ret;
 	struct adapter *padapter;
 	struct xmit_priv *pxmitpriv;
-	u8 thread_name[20] = "RTWHALXT";
-
+	u8 thread_name[20];
 
 	ret = _SUCCESS;
 	padapter = context;
 	pxmitpriv = &padapter->xmitpriv;
 
-	rtw_sprintf(thread_name, 20, "%s-"ADPT_FMT, thread_name, ADPT_ARG(padapter));
+	rtw_sprintf(thread_name, 20, "RTWHALXT-" ADPT_FMT, ADPT_ARG(padapter));
 	thread_enter(thread_name);
 
 	DBG_871X("start "FUNC_ADPT_FMT"\n", FUNC_ADPT_ARG(padapter));


