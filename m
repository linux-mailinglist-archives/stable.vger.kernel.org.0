Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A2E111C21
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfLCWkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbfLCWko (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8511207DD;
        Tue,  3 Dec 2019 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412844;
        bh=wdgNG4IGteDTjwi23AAJpKO2CxoHONNS90/cbg3/r04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccgx8bYQiz/29akss6kyveF6E1bmzFpSh8viYNbf0t38cVp6VZAfj6iIwc+tdHd6D
         LvvmUFnFAzuAl5zYu6nbTzx76xPJ5q+Fi/j/1iSLOrxxnoO/r7YMlHTAnw7Mj+8UTb
         O+fDa4ck8e/gDbTnqT7pWDJ22V9BJxu00/Dp6s38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 037/135] idr: Fix integer overflow in idr_for_each_entry
Date:   Tue,  3 Dec 2019 23:34:37 +0100
Message-Id: <20191203213013.544545879@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit f6341c5af4e6e15041be39976d16deca789555fa ]

If there is an entry at INT_MAX then idr_for_each_entry() will increment
id after handling it.  This is undefined behaviour, and is caught by
UBSAN.  Adding 1U to id forces the operation to be carried out as an
unsigned addition which (when assigned to id) will result in INT_MIN.
Since there is never an entry stored at INT_MIN, idr_get_next() will
return NULL, ending the loop as expected.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/idr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 4ec8986e5dfb6..ac6e946b6767b 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -185,7 +185,7 @@ static inline void idr_preload_end(void)
  * is convenient for a "not found" value.
  */
 #define idr_for_each_entry(idr, entry, id)			\
-	for (id = 0; ((entry) = idr_get_next(idr, &(id))) != NULL; ++id)
+	for (id = 0; ((entry) = idr_get_next(idr, &(id))) != NULL; id += 1U)
 
 /**
  * idr_for_each_entry_ul() - Iterate over an IDR's elements of a given type.
-- 
2.20.1



