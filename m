Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F04A32176C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhBVMrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231638AbhBVMnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D398164F47;
        Mon, 22 Feb 2021 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997640;
        bh=3l4b2QctpTS6W8gnQsLWpcDc2rUDE9y4sv6ETMiqy4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rXpmhi+UGg+BCiITq6KNbP5jnSH3roJRC6hfOKdxbMS5hQtWnZmRdPszEoPf9JtG0
         tywm0i3vpZL+8FkQ6iQr5nNGL25n4L5anOE7KC9LVB9O9c1AjlXfiiMisqiCVMaO6Y
         sAi1nbGfh8XD7LIQepFB+b4LZZxpicn/n7Ikxhlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 26/35] Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
Date:   Mon, 22 Feb 2021 13:36:22 +0100
Message-Id: <20210222121021.755935966@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
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
@@ -725,7 +725,8 @@ int set_foreign_p2m_mapping(struct gntta
 		unsigned long mfn, pfn;
 
 		/* Do not add to override if the map failed. */
-		if (map_ops[i].status)
+		if (map_ops[i].status != GNTST_okay ||
+		    (kmap_ops && kmap_ops[i].status != GNTST_okay))
 			continue;
 
 		if (map_ops[i].flags & GNTMAP_contains_pte) {


