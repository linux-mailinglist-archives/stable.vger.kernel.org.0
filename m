Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B647F1A9BB2
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896714AbgDOLFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:05:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47803 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896715AbgDOLEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:04:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 560575C01B0;
        Wed, 15 Apr 2020 07:04:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nDJ648
        22gy4vOux50FW4jCZUkK1w91FpYQyN2r0M3vc=; b=34DHgU2BJ6aBgeN53rY3te
        ljuyO3x6OZDqLXFbSPOfJS+kOGffAn78LDCODuZU9jt1GcsZMfsLHMi51KJOkNRU
        lTs555ipCWLTe0bIoXzPG1pWGXctbSINupac5/Dh4xdG/Kr3sK+sac2HXile4Maq
        dDSinBf3MSgqXb8yz/goeijysMY+khW4Ao5QuYh92MgPrpPLUpygRV+yTLu0M7cB
        o4BFfGpyizWpjE+ZAtuk2/TngHTge4QgJsvYH5sQl5zjzpVnPkGBvwmgim8K3a85
        OnFdvCA2Snps7maoAD4dR1Zdnt0xAAv0mOu8RF0hnzR7f3lLJf6VT4PtlOZc0VkQ
        ==
X-ME-Sender: <xms:SOqWXnLleUSxFk2Evw9haDQi6u6wsEs2LQXXWt2T227f-qqWpHyQqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SOqWXjUulc_LnMnNs2jv2ukQwMXZ9gcQaiSSvJRzvOrqlU0BmoiIHg>
    <xmx:SOqWXrQMX4JTk6oo0hkDJXL-1cGBaRZAv35_orKVBwAT3GJ87sRN2g>
    <xmx:SOqWXrCmShiUCoK9Kt-oKBvHhu65SlWapvegZnNe3NzymjEMOKdchQ>
    <xmx:T-qWXl8tG9cDG8bbK8ln6nG58sDN_yvOU4ZXtY1DsswpP9pjSOR38A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13AA33060069;
        Wed, 15 Apr 2020 07:04:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] XArray: Fix xa_find_next for large multi-index entries" failed to apply to 5.5-stable tree
To:     willy@infradead.org, bhelgaas@google.com, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:04:38 +0200
Message-ID: <158694867821974@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bd40b17ca49d7d110adf456e647701ce74de2241 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 31 Jan 2020 05:07:55 -0500
Subject: [PATCH] XArray: Fix xa_find_next for large multi-index entries

Coverity pointed out that xas_sibling() was shifting xa_offset without
promoting it to an unsigned long first, so the shift could cause an
overflow and we'd get the wrong answer.  The fix is obvious, and the
new test-case provokes UBSAN to report an error:
runtime error: shift exponent 60 is too large for 32-bit type 'int'

Fixes: 19c30f4dd092 ("XArray: Fix xa_find_after with multi-index entries")
Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 55c14e8c8859..8c7d7a8468b8 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -12,6 +12,9 @@
 static unsigned int tests_run;
 static unsigned int tests_passed;
 
+static const unsigned int order_limit =
+		IS_ENABLED(CONFIG_XARRAY_MULTI) ? BITS_PER_LONG : 1;
+
 #ifndef XA_DEBUG
 # ifdef __KERNEL__
 void xa_dump(const struct xarray *xa) { }
@@ -959,6 +962,20 @@ static noinline void check_multi_find_2(struct xarray *xa)
 	}
 }
 
+static noinline void check_multi_find_3(struct xarray *xa)
+{
+	unsigned int order;
+
+	for (order = 5; order < order_limit; order++) {
+		unsigned long index = 1UL << (order - 5);
+
+		XA_BUG_ON(xa, !xa_empty(xa));
+		xa_store_order(xa, 0, order - 4, xa_mk_index(0), GFP_KERNEL);
+		XA_BUG_ON(xa, xa_find_after(xa, &index, ULONG_MAX, XA_PRESENT));
+		xa_erase_index(xa, 0);
+	}
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1081,6 +1098,7 @@ static noinline void check_find(struct xarray *xa)
 	for (i = 2; i < 10; i++)
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
+	check_multi_find_3(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 1d9fab7db8da..acd1fad2e862 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1839,7 +1839,8 @@ static bool xas_sibling(struct xa_state *xas)
 	if (!node)
 		return false;
 	mask = (XA_CHUNK_SIZE << node->shift) - 1;
-	return (xas->xa_index & mask) > (xas->xa_offset << node->shift);
+	return (xas->xa_index & mask) >
+		((unsigned long)xas->xa_offset << node->shift);
 }
 
 /**

