Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB36E4B48B9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiBNJ5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344876AbiBNJ4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:56:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA09980907;
        Mon, 14 Feb 2022 01:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0966EB80DC4;
        Mon, 14 Feb 2022 09:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158D7C340E9;
        Mon, 14 Feb 2022 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831894;
        bh=ySxHgOW6CA8GA/+hWS9IcbwgoqR5pnPH0DyT5PJoAtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVXwv1BqzMqJzjwBonTLnUC4sYDNCGRYexU77HW00A5PFt5yAD3Afvpny8D64uJ1w
         eGBDyotlfxx/ry5kZiddqioMDVfxZhm0yJKdW3BPqEXuniguW5TkzCcnq//CERdD1m
         L27WbLIBFF3/IGgtlyHNcmbK6fOE9Em9CTM7xWdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 014/172] NFSD: Fix ia_size underflow
Date:   Mon, 14 Feb 2022 10:24:32 +0100
Message-Id: <20220214092506.873536206@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit e6faac3f58c7c4176b66f63def17a34232a17b0e upstream.

iattr::ia_size is a loff_t, which is a signed 64-bit type. NFSv3 and
NFSv4 both define file size as an unsigned 64-bit type. Thus there
is a range of valid file size values an NFS client can send that is
already larger than Linux can handle.

Currently decode_fattr4() dumps a full u64 value into ia_size. If
that value happens to be larger than S64_MAX, then ia_size
underflows. I'm about to fix up the NFSv3 behavior as well, so let's
catch the underflow in the common code path: nfsd_setattr().

Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -433,6 +433,10 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 			.ia_size	= iap->ia_size,
 		};
 
+		host_err = -EFBIG;
+		if (iap->ia_size < 0)
+			goto out_unlock;
+
 		host_err = notify_change(&init_user_ns, dentry, &size_attr, NULL);
 		if (host_err)
 			goto out_unlock;


