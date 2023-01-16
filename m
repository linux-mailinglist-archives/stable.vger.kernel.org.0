Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2477566CBD3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjAPRSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbjAPRRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:17:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE779530FE
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D4DF60F7C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83510C433D2;
        Mon, 16 Jan 2023 16:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888263;
        bh=UTUGVHfjiZ3kovA1VJU6mV1k7RcLHzT6tAF50x+DI7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do44243wYXHGq0lVmzTgom23N1RhTZfiZG7sABWNfpyE4k7o05f4RsMSvwVE+pFA4
         nbY9p0VG/LK/emQ1PlM7krbwkYQcRcp3rbq7blT1CWLgKWYQqrur18lk3Wk1HUfefJ
         F+Je4vobMIDdah5/5Vf7wLrQ4JJbHa9y3wAAYkgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Dickson <steved@redhat.com>,
        JianHong Yin <yin-jianhong@163.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 455/521] nfsd: fix handling of readdir in v4root vs. mount upcall timeout
Date:   Mon, 16 Jan 2023 16:51:57 +0100
Message-Id: <20230116154907.470062562@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit cad853374d85fe678d721512cecfabd7636e51f3 upstream.

If v4 READDIR operation hits a mountpoint and gets back an error,
then it will include that entry in the reply and set RDATTR_ERROR for it
to the error.

That's fine for "normal" exported filesystems, but on the v4root, we
need to be more careful to only expose the existence of dentries that
lead to exports.

If the mountd upcall times out while checking to see whether a
mountpoint on the v4root is exported, then we have no recourse other
than to fail the whole operation.

Cc: Steve Dickson <steved@redhat.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216777
Reported-by: JianHong Yin <yin-jianhong@163.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3102,6 +3102,17 @@ nfsd4_encode_dirent(void *ccdv, const ch
 	case nfserr_noent:
 		xdr_truncate_encode(xdr, start_offset);
 		goto skip_entry;
+	case nfserr_jukebox:
+		/*
+		 * The pseudoroot should only display dentries that lead to
+		 * exports. If we get EJUKEBOX here, then we can't tell whether
+		 * this entry should be included. Just fail the whole READDIR
+		 * with NFS4ERR_DELAY in that case, and hope that the situation
+		 * will resolve itself by the client's next attempt.
+		 */
+		if (cd->rd_fhp->fh_export->ex_flags & NFSEXP_V4ROOT)
+			goto fail;
+		/* fallthrough */
 	default:
 		/*
 		 * If the client requested the RDATTR_ERROR attribute,


