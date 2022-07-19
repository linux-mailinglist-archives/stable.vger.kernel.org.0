Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB1D579E7F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242539AbiGSNBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiGSM6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3135FAD5;
        Tue, 19 Jul 2022 05:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D5E0618EE;
        Tue, 19 Jul 2022 12:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A7BC341C6;
        Tue, 19 Jul 2022 12:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233428;
        bh=Vl4Pwnt45oXUZQsM1fX5l8ZaNSfjY4t1rnLD8VJxKg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJyFqPRnPTd39mwl1Wy7zKVaf7QozoU5tVD+IbqD9DrtKZO1b7HMrvNaH9WpV4atU
         JJ3e1nvCc7UKInXQtmtsBhodRsHkTN9cpZ4lSpRbCgW4Iqf1hch5qYQJ6cL4Wpb0OQ
         ML58dRv+6y1aTssMo0ZRfBqBNgKopdtTKSpGmcVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 093/231] NFSD: Decode NFSv4 birth time attribute
Date:   Tue, 19 Jul 2022 13:52:58 +0200
Message-Id: <20220719114722.627670095@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5b2f3e0777da2a5dd62824bbe2fdab1d12caaf8f ]

NFSD has advertised support for the NFSv4 time_create attribute
since commit e377a3e698fb ("nfsd: Add support for the birth time
attribute").

Igor Mammedov reports that Mac OS clients attempt to set the NFSv4
birth time attribute via OPEN(CREATE) and SETATTR if the server
indicates that it supports it, but since the above commit was
merged, those attempts now fail.

Table 5 in RFC 8881 lists the time_create attribute as one that can
be both set and retrieved, but the above commit did not add server
support for clients to provide a time_create attribute. IMO that's
a bug in our implementation of the NFSv4 protocol, which this commit
addresses.

Whether NFSD silently ignores the new birth time or actually sets it
is another matter. I haven't found another filesystem service in the
Linux kernel that enables users or clients to modify a file's birth
time attribute.

This commit reflects my (perhaps incorrect) understanding of whether
Linux users can set a file's birth time. NFSD will now recognize a
time_create attribute but it ignores its value. It clears the
time_create bit in the returned attribute bitmask to indicate that
the value was not used.

Reported-by: Igor Mammedov <imammedo@redhat.com>
Fixes: e377a3e698fb ("nfsd: Add support for the birth time attribute")
Tested-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 9 +++++++++
 fs/nfsd/nfsd.h    | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index da92e7d2ab6a..264c3a4629c9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -470,6 +470,15 @@ nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 			return nfserr_bad_xdr;
 		}
 	}
+	if (bmval[1] & FATTR4_WORD1_TIME_CREATE) {
+		struct timespec64 ts;
+
+		/* No Linux filesystem supports setting this attribute. */
+		bmval[1] &= ~FATTR4_WORD1_TIME_CREATE;
+		status = nfsd4_decode_nfstime4(argp, &ts);
+		if (status)
+			return status;
+	}
 	if (bmval[1] & FATTR4_WORD1_TIME_MODIFY_SET) {
 		u32 set_it;
 
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 4fc1fd639527..727754d56243 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -460,7 +460,8 @@ static inline bool nfsd_attrs_supported(u32 minorversion, const u32 *bmval)
 	(FATTR4_WORD0_SIZE | FATTR4_WORD0_ACL)
 #define NFSD_WRITEABLE_ATTRS_WORD1 \
 	(FATTR4_WORD1_MODE | FATTR4_WORD1_OWNER | FATTR4_WORD1_OWNER_GROUP \
-	| FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_MODIFY_SET)
+	| FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_CREATE \
+	| FATTR4_WORD1_TIME_MODIFY_SET)
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 #define MAYBE_FATTR4_WORD2_SECURITY_LABEL \
 	FATTR4_WORD2_SECURITY_LABEL
-- 
2.35.1



