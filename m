Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F04D8455
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241960AbiCNMXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243733AbiCNMVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6536B3630D;
        Mon, 14 Mar 2022 05:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB3ED60919;
        Mon, 14 Mar 2022 12:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6598C340E9;
        Mon, 14 Mar 2022 12:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260209;
        bh=46/45yPv03Vd7wdgIs0qyefA6DBhuuWV8uHgW4390cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6hxRWcgrI8QfXRpKMuIMf2VC6k1X7WAYwVmzvt3Mxysfwh8qXfFXjsmKrcn7vDHC
         WHcWj0/qZzNo88hgSatSHycrwFaFz5VHg7uX7tLeIEe8NFgQB+B5LknOc2R0frVRaL
         Fa9PbF7Mgqos22z8u5PA1OdFE0Xsc1sQTdjxotRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jean-Pierre=20Andr=C3=A9?= <jean-pierre.andre@wanadoo.fr>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.16 087/121] fuse: fix fileattr op failure
Date:   Mon, 14 Mar 2022 12:54:30 +0100
Message-Id: <20220314112746.547149171@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit a679a61520d8a7b0211a1da990404daf5cc80b72 upstream.

The fileattr API conversion broke lsattr on ntfs3g.

Previously the ioctl(... FS_IOC_GETFLAGS) returned an EINVAL error, but
after the conversion the error returned by the fuse filesystem was not
propagated back to the ioctl() system call, resulting in success being
returned with bogus values.

Fix by checking for outarg.result in fuse_priv_ioctl(), just as generic
ioctl code does.

Reported-by: Jean-Pierre André <jean-pierre.andre@wanadoo.fr>
Fixes: 72227eac177d ("fuse: convert to fileattr")
Cc: <stable@vger.kernel.org> # v5.13
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/ioctl.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -394,9 +394,12 @@ static int fuse_priv_ioctl(struct inode
 	args.out_args[1].value = ptr;
 
 	err = fuse_simple_request(fm, &args);
-	if (!err && outarg.flags & FUSE_IOCTL_RETRY)
-		err = -EIO;
-
+	if (!err) {
+		if (outarg.result < 0)
+			err = outarg.result;
+		else if (outarg.flags & FUSE_IOCTL_RETRY)
+			err = -EIO;
+	}
 	return err;
 }
 


