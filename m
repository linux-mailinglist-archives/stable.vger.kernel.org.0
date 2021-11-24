Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C245C555
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353100AbhKXN4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348322AbhKXNyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B3063275;
        Wed, 24 Nov 2021 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759152;
        bh=22Q/6LZHz12Qhq7HJAPM689ULLCMozEXI2V/OvoHeCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6LwIhgrtjfjD8KbIl/jJwNiEjI9in/LCIiufQctIyusz3t8+xDEqYMAmsfJqYBGt
         r7x+xZg6/Fh64c3SZUnfbIQmx0k5b6QQ0Flll3pD0pWjiK4CL4OBlxBT7KopMkDRnX
         OZ18PDqCuct/FBZHWPISrThx0bMz7NMPV8I1t1ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/279] NFSD: Fix exposure in nfsd4_decode_bitmap()
Date:   Wed, 24 Nov 2021 12:56:49 +0100
Message-Id: <20211124115723.022629849@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c0019b7db1d7ac62c711cda6b357a659d46428fe ]

rtm@csail.mit.edu reports:
> nfsd4_decode_bitmap4() will write beyond bmval[bmlen-1] if the RPC
> directs it to do so. This can cause nfsd4_decode_state_protect4_a()
> to write client-supplied data beyond the end of
> nfsd4_exchange_id.spo_must_allow[] when called by
> nfsd4_decode_exchange_id().

Rewrite the loops so nfsd4_decode_bitmap() cannot iterate beyond
@bmlen.

Reported by: rtm@csail.mit.edu
Fixes: d1c263a031e8 ("NFSD: Replace READ* macros in nfsd4_decode_fattr()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index cf030ebe28275..266d5152c3216 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -288,11 +288,8 @@ nfsd4_decode_bitmap4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen)
 	p = xdr_inline_decode(argp->xdr, count << 2);
 	if (!p)
 		return nfserr_bad_xdr;
-	i = 0;
-	while (i < count)
-		bmval[i++] = be32_to_cpup(p++);
-	while (i < bmlen)
-		bmval[i++] = 0;
+	for (i = 0; i < bmlen; i++)
+		bmval[i] = (i < count) ? be32_to_cpup(p++) : 0;
 
 	return nfs_ok;
 }
-- 
2.33.0



