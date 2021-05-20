Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC3338A148
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhETJ3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232124AbhETJ2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052D3613D4;
        Thu, 20 May 2021 09:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502797;
        bh=NZQEPQYccewLr+VRuJ61RYKbXOqWqPAxAxbdO+r18iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLWSrhFrUdl9eNVFUCbycbGD1s0tWrAKK22e4lA1FpquP/1Dvsw3uxNwE2YpJuHbM
         B9xXTvq0b1RC6HTzUtBlMJbZO+NL/hiT7dyzYanwAqzDwgeiIjc+2DgrqcqefdGV5L
         udQZbXiYQ3+oLjfp0C5Z0YXzcoo7eDKNQdaEFwv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 07/47] isdn: capi: fix mismatched prototypes
Date:   Thu, 20 May 2021 11:22:05 +0200
Message-Id: <20210520092053.794437463@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
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
@@ -721,7 +721,7 @@ u16 capi20_put_message(struct capi20_app
  * Return value: CAPI result code
  */
 
-u16 capi20_get_manufacturer(u32 contr, u8 *buf)
+u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN])
 {
 	struct capi_ctr *ctr;
 	u16 ret;
@@ -787,7 +787,7 @@ u16 capi20_get_version(u32 contr, struct
  * Return value: CAPI result code
  */
 
-u16 capi20_get_serial(u32 contr, u8 *serial)
+u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN])
 {
 	struct capi_ctr *ctr;
 	u16 ret;


