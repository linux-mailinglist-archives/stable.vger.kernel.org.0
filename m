Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC4499592
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359202AbiAXUxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43674 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391902AbiAXUt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5BC160B11;
        Mon, 24 Jan 2022 20:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC08C340E5;
        Mon, 24 Jan 2022 20:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057398;
        bh=u/UP1OsSzDo7P7Ajc+9f8LDlJZ84k4hEdHMP1AEqTSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GxuEEF9f55vWWvMtMQuLG44hec6zwsKYYStcU+qtL3dzdFGQ7Tdj+M8ILyLu4CIt
         c1TH3Zuj2d8OUzod/bUuo8sErVHyG9nSmrYs0Wj0mCuvJtOQN9A/N4f1iwU/cM5EYS
         8quYFKckKnb8cRpfXjzKARgSV5Wzsmoj58Zym5VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 5.15 800/846] bitops: protect find_first_{,zero}_bit properly
Date:   Mon, 24 Jan 2022 19:45:17 +0100
Message-Id: <20220124184128.539745866@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>

commit b7ec62d7ee0f0b8af6ba190501dff7f9ee6545ca upstream.

find_first_bit() and find_first_zero_bit() are not protected with
ifdefs as other functions in find.h. It causes build errors on some
platforms if CONFIG_GENERIC_FIND_FIRST_BIT is enabled.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Fixes: 2cc7b6a44ac2 ("lib: add fast path for find_first_*_bit() and find_last_bit()")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/bitops/find.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/bitops/find.h b/include/asm-generic/bitops/find.h
index 0d132ee2a291..835f959a25f2 100644
--- a/include/asm-generic/bitops/find.h
+++ b/include/asm-generic/bitops/find.h
@@ -97,6 +97,7 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
+#ifndef find_first_bit
 /**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
@@ -116,7 +117,9 @@ unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
 
 	return _find_first_bit(addr, size);
 }
+#endif
 
+#ifndef find_first_zero_bit
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
  * @addr: The address to start the search at
@@ -136,6 +139,8 @@ unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
 
 	return _find_first_zero_bit(addr, size);
 }
+#endif
+
 #else /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifndef find_first_bit
-- 
2.34.1



