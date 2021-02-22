Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0013D32164A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhBVMUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhBVMR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71A4164F16;
        Mon, 22 Feb 2021 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996232;
        bh=KFpzYuWU8/cmTpjzk3Ft6G3yC2pOCP/AnwC6+FNuimI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7YbfvIy+wRI7lOUazx2PzAHvfQE27kE/HjvaT0swaeLAblOBdT9DA85ZcKeMnJ/o
         uM4D58Q3YI9CwoNJEZN0aAX8JriPOvGCoPBPgYGiDPL8qptnG4jpfdK4QVudljlzTh
         NPc2GbQiMJ0ShLmai6LRcOsah2jthR14aU+Xrw7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 41/50] Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
Date:   Mon, 22 Feb 2021 13:13:32 +0100
Message-Id: <20210222121026.681028797@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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


