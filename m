Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5441D8291
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbgERR5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731803AbgERR5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A10C20715;
        Mon, 18 May 2020 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824650;
        bh=3rJdlKPl8wLgn6izT/OQntL7glddycl6v36dvt8Vq/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMN5Ng+mX3TrgWR0hSulH/ubEwpSJCEFsNxOZUZuSd9rll69IdKKKx5XmcSbs8uyb
         DnaH07HvCpwORoorruiTjpoqm2JvOpDXGwIj9SwY7QczoGTNHEKV/rIcwGKfMJ34Br
         FvGgcWv8ccSWSeWYVYYdYC/8KFxfFiyZ5DtoCK2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 096/147] gcc-10: disable zero-length-bounds warning for now
Date:   Mon, 18 May 2020 19:36:59 +0200
Message-Id: <20200518173525.468110406@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5c45de21a2223fe46cf9488c99a7fbcf01527670 upstream.

This is a fine warning, but we still have a number of zero-length arrays
in the kernel that come from the traditional gcc extension.  Yes, they
are getting converted to flexible arrays, but in the meantime the gcc-10
warning about zero-length bounds is very verbose, and is hiding other
issues.

I missed one actual build failure because it was hidden among hundreds
of lines of warning.  Thankfully I caught it on the second go before
pushing things out, but it convinced me that I really need to disable
the new warnings for now.

We'll hopefully be all done with our conversion to flexible arrays in
the not too distant future, and we can then re-enable this warning.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -856,6 +856,9 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 # disable stringop warnings in gcc 8+
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
+# We'll want to enable this eventually, but it's not going away for 5.7 at least
+KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
+
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
 


