Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A848738AB21
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbhETLUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240165AbhETLRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:17:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BDB161952;
        Thu, 20 May 2021 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505375;
        bh=cOc6lcQ5YoBHcNEo7t7yxygIjdYW5ATkR8jzQrmKxU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iuwb7ltbI2GLMLJNsN+2PYX0sktrJPO01uvWfLeEJy87cHEjfW4upHzaTFS7dmuJh
         LXnulACjl0j+5FLqcaQJ1R6LVoLbwztdT2IAeksxXm2s1lJ8yVwbVfjmSFb+lXBkYN
         rMmaQZjK4jUuEZlpRehodJlP6Nec2g3ggrnE+ElY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 105/190] media: dvb-usb-remote: fix dvb_usb_nec_rc_key_to_event type mismatch
Date:   Thu, 20 May 2021 11:22:49 +0200
Message-Id: <20210520092105.665311713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0fa430e96d3c3561a78701f51fd8593da68b8474 ]

gcc-11 warns about the prototype not exactly matching the function
definition:

drivers/media/usb/dvb-usb/dvb-usb-remote.c:363:20: error: argument 2 of type ‘u8[5]’ {aka ‘unsigned char[5]’} with mismatched bound [-Werror=array-parameter=]
  363 |                 u8 keybuf[5], u32 *event, int *state)
      |                 ~~~^~~~~~~~~
In file included from drivers/media/usb/dvb-usb/dvb-usb-common.h:13,
                 from drivers/media/usb/dvb-usb/dvb-usb-remote.c:9:
drivers/media/usb/dvb-usb/dvb-usb.h:490:65: note: previously declared as ‘u8[]’ {aka ‘unsigned char[]’}
  490 | extern int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *, u8[], u32 *, int *);
      |                                                                 ^~~~

Fixes: 776338e121b9 ("[PATCH] dvb: Add generalized dvb-usb driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dvb-usb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index ce4c4e3b58bb..dd80b737d4da 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -466,7 +466,8 @@ extern int dvb_usb_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16,int)
 extern int dvb_usb_generic_write(struct dvb_usb_device *, u8 *, u16);
 
 /* commonly used remote control parsing */
-extern int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *, u8[], u32 *, int *);
+int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d, u8 keybuf[5],
+				u32 *event, int *state);
 
 /* commonly used firmware download types and function */
 struct hexline {
-- 
2.30.2



