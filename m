Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519A8321701
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhBVMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhBVMjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA86D64E67;
        Mon, 22 Feb 2021 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997509;
        bh=KFpzYuWU8/cmTpjzk3Ft6G3yC2pOCP/AnwC6+FNuimI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW53+pQZCfgCc/z2jRFYYL8RFoNSLicgmptK4vjk0eK2l7t0/fwFctkK2o9fAFkfB
         uS0xZZfW2FOrOLKBHuPuyEacSzY+RVh6lR7CbQnJvhqSSN0T2UsmrZiiXu4Tz4emCk
         fIwJHQX466/ZvVn2yF67wJ/X+95jExOteXP6BW1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 46/57] Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
Date:   Mon, 22 Feb 2021 13:36:12 +0100
Message-Id: <20210222121033.927460153@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit b512e1b077e5ccdbd6e225b15d934ab12453b70a upstream.

We should not set up further state if either mapping failed; paying
attention to just the user mapping's status isn't enough.

Also use GNTST_okay instead of implying its value (zero).

This is part of XSA-361.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -708,7 +708,8 @@ int set_foreign_p2m_mapping(struct gntta
 		unsigned long mfn, pfn;
 
 		/* Do not add to override if the map failed. */
-		if (map_ops[i].status)
+		if (map_ops[i].status != GNTST_okay ||
+		    (kmap_ops && kmap_ops[i].status != GNTST_okay))
 			continue;
 
 		if (map_ops[i].flags & GNTMAP_contains_pte) {


