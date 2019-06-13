Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280DE43FF9
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390271AbfFMQB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731409AbfFMIsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E6E21473;
        Thu, 13 Jun 2019 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415681;
        bh=+YhvyYjFQkGYkxkG8w8hSniLgZgLFRrSUX4E0pMH/Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnCvcjLD68V/O0zVtULw2v53QDYBuXd0PB4C0Yhr6SxFTvlwwCvExy/jyMbTn7Whi
         9YVaJU3yS1fI+df4lhC+0dIptigUD95KqRab5NN7nevffDwlg8UMIrYpcOmpvB8A0d
         uIXzWvzdmf5qCLvH4z75Hfiwl6WiSibZYJVAgT8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 087/155] nfsd: avoid uninitialized variable warning
Date:   Thu, 13 Jun 2019 10:33:19 +0200
Message-Id: <20190613075657.970708807@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0ab88ca4bcf18ba21058d8f19220f60afe0d34d8 ]

clang warns that 'contextlen' may be accessed without an initialization:

fs/nfsd/nfs4xdr.c:2911:9: error: variable 'contextlen' is uninitialized when used here [-Werror,-Wuninitialized]
                                                                contextlen);
                                                                ^~~~~~~~~~
fs/nfsd/nfs4xdr.c:2424:16: note: initialize the variable 'contextlen' to silence this warning
        int contextlen;
                      ^
                       = 0

Presumably this cannot happen, as FATTR4_WORD2_SECURITY_LABEL is
set if CONFIG_NFSD_V4_SECURITY_LABEL is enabled.
Adding another #ifdef like the other two in this function
avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 3de42a729093..a3a3455826aa 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2420,8 +2420,10 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	__be32 status;
 	int err;
 	struct nfs4_acl *acl = NULL;
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 	void *context = NULL;
 	int contextlen;
+#endif
 	bool contextsupport = false;
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
 	u32 minorversion = resp->cstate.minorversion;
@@ -2906,12 +2908,14 @@ out_acl:
 			*p++ = cpu_to_be32(NFS4_CHANGE_TYPE_IS_TIME_METADATA);
 	}
 
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 	if (bmval2 & FATTR4_WORD2_SECURITY_LABEL) {
 		status = nfsd4_encode_security_label(xdr, rqstp, context,
 								contextlen);
 		if (status)
 			goto out;
 	}
+#endif
 
 	attrlen = htonl(xdr->buf->len - attrlen_offset - 4);
 	write_bytes_to_xdr_buf(xdr->buf, attrlen_offset, &attrlen, 4);
-- 
2.20.1



