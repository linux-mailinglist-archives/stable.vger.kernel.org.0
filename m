Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE576DA17A
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436993AbfJPVwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436896AbfJPVwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:52:54 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943B420872;
        Wed, 16 Oct 2019 21:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262772;
        bh=OBdtrm8pJtajj5WunNduBtqbGjzE7rTRWzKQSZySMEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fHM4ujKbIn6mUCLxrYbvnoa8XJG8W2rBsVanOR5eRr88b+SU4tTueVGSKq3hj3Qvj
         8Q54bCV/nLxG9W+WKhcNFfO0tx2JHbxMOaEQShEwAmUrMdTAafmedS3zynJ5SNxaiI
         q6YQSz0HnvUNUJvc24+xHcTdoAil8cVeeYX09G/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 13/79] fs: nfs: Fix possible null-pointer dereferences in encode_attrs()
Date:   Wed, 16 Oct 2019 14:49:48 -0700
Message-Id: <20191016214741.602462781@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit e2751463eaa6f9fec8fea80abbdc62dbc487b3c5 ]

In encode_attrs(), there is an if statement on line 1145 to check
whether label is NULL:
    if (label && (attrmask[2] & FATTR4_WORD2_SECURITY_LABEL))

When label is NULL, it is used on lines 1178-1181:
    *p++ = cpu_to_be32(label->lfs);
    *p++ = cpu_to_be32(label->pi);
    *p++ = cpu_to_be32(label->len);
    p = xdr_encode_opaque_fixed(p, label->label, label->len);

To fix these bugs, label is checked before being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 1cb50bb898b01..15cd9db6d616d 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -1123,7 +1123,7 @@ static void encode_attrs(struct xdr_stream *xdr, const struct iattr *iap,
 		} else
 			*p++ = cpu_to_be32(NFS4_SET_TO_SERVER_TIME);
 	}
-	if (bmval[2] & FATTR4_WORD2_SECURITY_LABEL) {
+	if (label && (bmval[2] & FATTR4_WORD2_SECURITY_LABEL)) {
 		*p++ = cpu_to_be32(label->lfs);
 		*p++ = cpu_to_be32(label->pi);
 		*p++ = cpu_to_be32(label->len);
-- 
2.20.1



