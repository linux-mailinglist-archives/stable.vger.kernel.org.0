Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD7638A1BF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhETJev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232171AbhETJc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3CC613CC;
        Thu, 20 May 2021 09:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502903;
        bh=sQUr7wMd8s3DIqyuZRmOuqrOcv9uqv1kTGFw0veOYtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPQlpu+yxVwBa1A6iehD04uZuYMewp6dSnGDM3VzEYxgoNnZfRktbHtM5Yxu8gTmv
         gQ61BOJujOOfJO7xt2wmpzsy/XezYk9L5EPwsNtmcHFjlS8mpDYns7gSMoC6mClJ9R
         Ed6K6cL8TMsyu3pT0kjTmx8aosHroBY/Bo/I5jgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 05/37] isdn: capi: fix mismatched prototypes
Date:   Thu, 20 May 2021 11:22:26 +0200
Message-Id: <20210520092052.444796765@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 5ee7d4c7fbc9d3119a20b1c77d34003d1f82ac26 upstream.

gcc-11 complains about a prototype declaration that is different
from the function definition:

drivers/isdn/capi/kcapi.c:724:44: error: argument 2 of type ‘u8 *’ {aka ‘unsigned char *’} declared as a pointer [-Werror=array-parameter=]
  724 | u16 capi20_get_manufacturer(u32 contr, u8 *buf)
      |                                        ~~~~^~~
In file included from drivers/isdn/capi/kcapi.c:13:
drivers/isdn/capi/kcapi.h:62:43: note: previously declared as an array ‘u8[64]’ {aka ‘unsigned char[64]’}
   62 | u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN]);
      |                                        ~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/isdn/capi/kcapi.c:790:38: error: argument 2 of type ‘u8 *’ {aka ‘unsigned char *’} declared as a pointer [-Werror=array-parameter=]
  790 | u16 capi20_get_serial(u32 contr, u8 *serial)
      |                                  ~~~~^~~~~~
In file included from drivers/isdn/capi/kcapi.c:13:
drivers/isdn/capi/kcapi.h:64:37: note: previously declared as an array ‘u8[8]’ {aka ‘unsigned char[8]’}
   64 | u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN]);
      |                                  ~~~^~~~~~~~~~~~~~~~~~~~~~~

Change the definition to make them match.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/capi/kcapi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -846,7 +846,7 @@ EXPORT_SYMBOL(capi20_put_message);
  * Return value: CAPI result code
  */
 
-u16 capi20_get_manufacturer(u32 contr, u8 *buf)
+u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN])
 {
 	struct capi_ctr *ctr;
 	u16 ret;
@@ -916,7 +916,7 @@ EXPORT_SYMBOL(capi20_get_version);
  * Return value: CAPI result code
  */
 
-u16 capi20_get_serial(u32 contr, u8 *serial)
+u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN])
 {
 	struct capi_ctr *ctr;
 	u16 ret;


