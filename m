Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE766CDA6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbjAPRiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbjAPRh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054B24903C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD42DB81091
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1140BC433D2;
        Mon, 16 Jan 2023 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889255;
        bh=D3wtdaAEgSSN8eytQiyrY0vdFDRhPDbD/yMMakPaVpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q83VpOEpkWmJF1y2MgRFWLFKo7xIgqUdRcDbBypyLP+uelkFVdRS/KE04hvoRGSxT
         hbPdkh9wdMvIKWFDTMPfxdBqycb0nApdXaUy/MWlUEk03LyoNe0dD/LRkbDTmnCkFt
         +nkEkbWujELB2JLb6ueERzXuq8Q3wz6D6oPBnbuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve Dickson <steved@redhat.com>,
        JianHong Yin <yin-jianhong@163.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.14 318/338] nfsd: fix handling of readdir in v4root vs. mount upcall timeout
Date:   Mon, 16 Jan 2023 16:53:11 +0100
Message-Id: <20230116154834.995331942@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
@@ -3060,6 +3060,17 @@ nfsd4_encode_dirent(void *ccdv, const ch
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


