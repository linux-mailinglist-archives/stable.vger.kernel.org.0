Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C22259B69
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgIARBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgIAPUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6532078B;
        Tue,  1 Sep 2020 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973654;
        bh=HnVgmumWpwDBdBjrYA7sTpJHvI03QBKfSJazXmbciLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZaaW8d5dNKMSGoIUgOpLwHbk6f/rYp40xyEmS3LceLNZVdFTXxmXkkSKAvaiDMZ2
         Ix7YX7jz0rQhBBJC97kj4gSlk53RSNZT60lZGDL6XqyxW9ifthWK3psV2H2iPrnHi9
         iCFYcbLXrmXsQuysa1hbG+RpMMXJqsCm4UNGH15s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brooke Basile <brookebasile@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.14 85/91] USB: gadget: u_f: Unbreak offset calculation in VLAs
Date:   Tue,  1 Sep 2020 17:10:59 +0200
Message-Id: <20200901150932.386937578@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit bfd08d06d978d0304eb6f7855b548aa2cd1c5486 upstream.

Inadvertently the commit b1cd1b65afba ("USB: gadget: u_f: add overflow checks
to VLA macros") makes VLA macros to always return 0 due to different scope of
two variables of the same name. Obviously we need to have only one.

Fixes: b1cd1b65afba ("USB: gadget: u_f: add overflow checks to VLA macros")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brooke Basile <brookebasile@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20200826192119.56450-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/u_f.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/u_f.h
+++ b/drivers/usb/gadget/u_f.h
@@ -28,9 +28,9 @@
 		size_t offset = 0;					       \
 		if (groupname##__next != SIZE_MAX) {			       \
 			size_t align_mask = __alignof__(type) - 1;	       \
-			size_t offset = (groupname##__next + align_mask)       \
-					 & ~align_mask;			       \
 			size_t size = array_size(n, sizeof(type));	       \
+			offset = (groupname##__next + align_mask) &	       \
+				  ~align_mask;				       \
 			if (check_add_overflow(offset, size,		       \
 					       &groupname##__next)) {          \
 				groupname##__next = SIZE_MAX;		       \
@@ -46,8 +46,8 @@
 		size_t offset = 0;						\
 		if (groupname##__next != SIZE_MAX) {				\
 			size_t align_mask = __alignof__(type) - 1;		\
-			size_t offset = (groupname##__next + align_mask)	\
-					 & ~align_mask;				\
+			offset = (groupname##__next + align_mask) &		\
+				  ~align_mask;					\
 			if (check_add_overflow(offset, groupname##_##name##__sz,\
 							&groupname##__next)) {	\
 				groupname##__next = SIZE_MAX;			\


