Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE29259A93
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgIAQvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgIAP0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:26:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA9A1207D3;
        Tue,  1 Sep 2020 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973962;
        bh=Qj7JQS+ohLx5lQJpKyzZQKyNdacmCCnN1LoA2xLvZVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XKi8abyyDv47fXrU+NTuHhKeex/OO4L7lUWjhkhB2LiZoY32nEGKMiR2ISZGZ4Ot
         BdNnkQ4FMl1rGOSFk8OmgTyp3n7fR2Z41OzaNTj1Va1F+RnwG2xQOLdkGEKVMng0GP
         N95LhmHc2r7j2HHggnABc0pjs0fZX+4IFFNipcWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brooke Basile <brookebasile@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.19 116/125] USB: gadget: u_f: Unbreak offset calculation in VLAs
Date:   Tue,  1 Sep 2020 17:11:11 +0200
Message-Id: <20200901150940.303347212@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
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
@@ -25,9 +25,9 @@
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
@@ -43,8 +43,8 @@
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


