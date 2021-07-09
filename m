Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806AC3C246D
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhGINWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232355AbhGINWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A056613C0;
        Fri,  9 Jul 2021 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836794;
        bh=gs/iwV97RTWQsFLmC09p3GByGLkEda3sj8zGr7drqTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAPLuD3Ut909FoDsE7PT9WgydD4dJQLGgwTwTnjKlaOKS19+nvMR17dZUFpAT42BI
         NTHgte7ja3+mb1zJ3mnB0RB3JTdVz3PjA1cREaJUq5lyVur3uYINk1k3zoYtDaTR3Y
         lS+jbcDtLPXzFyC1ZzQp8FXTl2B4Ar7l2y2qagto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Stefani Seibold <stefani@seibold.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Matthew Weber <matthew.weber@collins.com>
Subject: [PATCH 4.14 22/25] kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit
Date:   Fri,  9 Jul 2021 15:18:53 +0200
Message-Id: <20210709131641.269666523@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 8a866fee3909c49738e1c4429a8d2b9bf27e015d upstream.

If you try to store u64 in a kfifo (or a struct with u64 members),
then the buf member of __STRUCT_KFIFO_PTR will cause 4 bytes
padding due to alignment (note that struct __kfifo is 20 bytes
on 32 bit).

That in turn causes the __is_kfifo_ptr() to fail, which is caught
by kfifo_alloc(), which now returns EINVAL.

So, ensure that __is_kfifo_ptr() compares to the right structure.

Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Matthew Weber <matthew.weber@collins.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kfifo.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -113,7 +113,8 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
  * array is a part of the structure and the fifo type where the array is
  * outside of the fifo structure.
  */
-#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
+#define	__is_kfifo_ptr(fifo) \
+	(sizeof(*fifo) == sizeof(STRUCT_KFIFO_PTR(typeof(*(fifo)->type))))
 
 /**
  * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object


