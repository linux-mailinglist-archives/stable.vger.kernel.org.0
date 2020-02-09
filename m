Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4890156A39
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 13:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgBIM5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:57:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35273 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBIM5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:57:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E650A21AF2;
        Sun,  9 Feb 2020 07:57:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jRrAGl
        JL6F3xzuCnEzdQZ3fWHtYQwL74lRsuxvtm9Lw=; b=k9/4rY33OMYCVpvi/+KU3l
        RSLkKQv47octPUmrCTDCkW6ghTRVJ/b1c3iJrJwZcwvGiiu97ksir2dhpP5jneok
        t5ayzmX1yqlwXmhqGiDr8DfwjNYnKiPOq4xk6geQhgVhu4Y/CcwtZH1hlyxyiuIg
        oq+ZTsxiGiFhFuCvNst2J8RBeqQRbS9mKYqTSWy4WiA156Tbzv2jVnK7Pv9oGShN
        ZeTTAbZVqiW4lbjgiH0h6BGvmRuAu6V0BoCpdigwKNLyduCdlrXH+SZDFDP9K1WR
        0chqn9c/RLeIONHJzMLaPVethMTt7SFPJkgAaSAwTTaFHUA5GK7PxYkpNaKCt3LQ
        ==
X-ME-Sender: <xms:vAFAXvy0krl1DfUUkII3EUArX2UbTYWBGyettPdHPi0HMSfm7lKZCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vAFAXnb48jxO6OxIfMHPYEmu_kY4XCkzAth13XbIcJSgI1x05bbJew>
    <xmx:vAFAXhTYSA2bNHC2fJBLpuVFsxkMlheXPz3EDYWLtlqALY5eW6o32Q>
    <xmx:vAFAXhy5xAcxK2-W55M82InVVR-v0YyJrCs8elBXvURfr95qdcETEQ>
    <xmx:vAFAXhw14U7mbXXaNBe2vArbUxty39ZFNfSL-IYpxyDP7zn3cq-eUw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id BDB9B328005D;
        Sun,  9 Feb 2020 07:57:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] NFS: Fix memory leaks and corruption in readdir" failed to apply to 4.9-stable tree
To:     trondmy@gmail.com, Anna.Schumaker@Netapp.com, bcodding@redhat.com,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:24:10 +0100
Message-ID: <158124745033180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b310319c6a8ce708f1033d57145e2aa027a883c Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trondmy@gmail.com>
Date: Sun, 2 Feb 2020 17:53:53 -0500
Subject: [PATCH] NFS: Fix memory leaks and corruption in readdir

nfs_readdir_xdr_to_array() must not exit without having initialised
the array, so that the page cache deletion routines can safely
call nfs_readdir_clear_array().
Furthermore, we should ensure that if we exit nfs_readdir_filler()
with an error, we free up any page contents to prevent a leak
if we try to fill the page again.

Fixes: 11de3b11e08c ("NFS: Fix a memory leak in nfs_readdir")
Cc: stable@vger.kernel.org # v2.6.37+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 6427a8a8d61a..451c48cdb1c2 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -162,6 +162,17 @@ typedef struct {
 	bool eof;
 } nfs_readdir_descriptor_t;
 
+static
+void nfs_readdir_init_array(struct page *page)
+{
+	struct nfs_cache_array *array;
+
+	array = kmap_atomic(page);
+	memset(array, 0, sizeof(struct nfs_cache_array));
+	array->eof_index = -1;
+	kunmap_atomic(array);
+}
+
 /*
  * we are freeing strings created by nfs_add_to_readdir_array()
  */
@@ -174,6 +185,7 @@ void nfs_readdir_clear_array(struct page *page)
 	array = kmap_atomic(page);
 	for (i = 0; i < array->size; i++)
 		kfree(array->array[i].string.name);
+	array->size = 0;
 	kunmap_atomic(array);
 }
 
@@ -610,6 +622,8 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 	int status = -ENOMEM;
 	unsigned int array_size = ARRAY_SIZE(pages);
 
+	nfs_readdir_init_array(page);
+
 	entry.prev_cookie = 0;
 	entry.cookie = desc->last_cookie;
 	entry.eof = 0;
@@ -626,8 +640,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 	}
 
 	array = kmap(page);
-	memset(array, 0, sizeof(struct nfs_cache_array));
-	array->eof_index = -1;
 
 	status = nfs_readdir_alloc_pages(pages, array_size);
 	if (status < 0)
@@ -682,6 +694,7 @@ int nfs_readdir_filler(void *data, struct page* page)
 	unlock_page(page);
 	return 0;
  error:
+	nfs_readdir_clear_array(page);
 	unlock_page(page);
 	return ret;
 }

