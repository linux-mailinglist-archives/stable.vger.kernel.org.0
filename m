Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769DB19B036
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbgDAQZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387783AbgDAQZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB0120BED;
        Wed,  1 Apr 2020 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758307;
        bh=P7eaBlYz4GzVkyvhowH9g6w/cqbHD7kEmXW8Sh3FLOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt7NeYoSbpBtC1R+3x3QNYCLqBpjBWwdwFTPAeDwRUHEsGkcnrbaF0YvKOph3WfSs
         8k6EZ541wHWqDAi6DRAiyaR/Id+d8lf4eb1ajAERkfcKi8qps8KYVMRL4NYee2zM63
         C4rUNXarZTnYlgb+AYJAWY0VNX36njcB63NrVdBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Syromiatnikov <esyr@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 050/116] Input: avoid BIT() macro usage in the serio.h UAPI header
Date:   Wed,  1 Apr 2020 18:17:06 +0200
Message-Id: <20200401161548.975886443@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Syromiatnikov <esyr@redhat.com>

commit 52afa505a03d914081f40cb869a3248567a57573 upstream.

The commit 19ba1eb15a2a ("Input: psmouse - add a custom serio protocol
to send extra information") introduced usage of the BIT() macro
for SERIO_* flags; this macro is not provided in UAPI headers.
Replace if with similarly defined _BITUL() macro defined
in <linux/const.h>.

Fixes: 19ba1eb15a2a ("Input: psmouse - add a custom serio protocol to send extra information")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Cc: <stable@vger.kernel.org> # v5.0+
Link: https://lore.kernel.org/r/20200324041341.GA32335@asgard.redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/serio.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/uapi/linux/serio.h
+++ b/include/uapi/linux/serio.h
@@ -9,7 +9,7 @@
 #ifndef _UAPI_SERIO_H
 #define _UAPI_SERIO_H
 
-
+#include <linux/const.h>
 #include <linux/ioctl.h>
 
 #define SPIOCSTYPE	_IOW('q', 0x01, unsigned long)
@@ -18,10 +18,10 @@
 /*
  * bit masks for use in "interrupt" flags (3rd argument)
  */
-#define SERIO_TIMEOUT	BIT(0)
-#define SERIO_PARITY	BIT(1)
-#define SERIO_FRAME	BIT(2)
-#define SERIO_OOB_DATA	BIT(3)
+#define SERIO_TIMEOUT	_BITUL(0)
+#define SERIO_PARITY	_BITUL(1)
+#define SERIO_FRAME	_BITUL(2)
+#define SERIO_OOB_DATA	_BITUL(3)
 
 /*
  * Serio types


