Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A626D13342D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgAGVAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgAGVAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9387D24676;
        Tue,  7 Jan 2020 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430822;
        bh=B+rIfLlp5nYJGhKLBRlNihaDw5B3p2Wcr3bepgTOkg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWeqtCyauPas3aTw4cYiOhFnFThxaM1YPZ/cSeo3l4JdpGMe54j98/5fMHig84kFF
         FAMpdqjJJL5rPlI0Pw0U9F8mHgfw2Qgo0DTpyraQM7pyLTME9uGq16KC4O48aV9bnF
         ogwzzqS+LGlqJsaUSkEaGo0ho7DBMWK45D8kMuxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 110/191] gpio: xtensa: fix driver build
Date:   Tue,  7 Jan 2020 21:53:50 +0100
Message-Id: <20200107205338.872655905@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 634f0348fe336fce8f6cab1933139115e983ed2f upstream.

Commit cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr") removed
{RSR,WSR}_CPENABLE from xtensa code, but did not fix up all users,
breaking gpio-xtensa driver build. Update gpio-xtensa to use
new xtensa_{get,set}_sr API.

Cc: stable@vger.kernel.org # v5.0+
Fixes: cad6fade6e78 ("xtensa: clean up WSR*/RSR*/get_sr/set_sr")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-xtensa.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-xtensa.c
+++ b/drivers/gpio/gpio-xtensa.c
@@ -44,15 +44,14 @@ static inline unsigned long enable_cp(un
 	unsigned long flags;
 
 	local_irq_save(flags);
-	RSR_CPENABLE(*cpenable);
-	WSR_CPENABLE(*cpenable | BIT(XCHAL_CP_ID_XTIOP));
-
+	*cpenable = xtensa_get_sr(cpenable);
+	xtensa_set_sr(*cpenable | BIT(XCHAL_CP_ID_XTIOP), cpenable);
 	return flags;
 }
 
 static inline void disable_cp(unsigned long flags, unsigned long cpenable)
 {
-	WSR_CPENABLE(cpenable);
+	xtensa_set_sr(cpenable, cpenable);
 	local_irq_restore(flags);
 }
 


