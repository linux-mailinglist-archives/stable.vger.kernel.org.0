Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B263059DB48
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354263AbiHWKRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353299AbiHWKON (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:14:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE54972FE6;
        Tue, 23 Aug 2022 01:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F24CCE1B2C;
        Tue, 23 Aug 2022 08:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F40CC433D6;
        Tue, 23 Aug 2022 08:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245191;
        bh=nJdKeWgqbwSrC1zoMSnCLvplncVpAtSgrQGy4V7rxN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4fN/GcmafdOrofZIY+h4OaBD3K3xRQl0a/hAVw24golU+X5LbXw9ok76wbpPYi+h
         HxOMJLus1rwqkbrd0hQjeXce6LhHL45hqeD0USRn9sbSAw/u87YKwdfDVf8zpHuYs9
         Aar56weC+gO9Wkyc6wP2BKffv3nzsTVCl0ApDDZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 244/244] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
Date:   Tue, 23 Aug 2022 10:26:43 +0200
Message-Id: <20220823080107.796989859@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 29d650f7e3ab55283b89c9f5883d0c256ce478b5 ]

Syzbot tripped over the following complaint from the kernel:

WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/util.c:597

While trying to run XFS_IOC_GETBMAP against the following structure:

struct getbmap fubar = {
	.bmv_count	= 0x22dae649,
};

Obviously, this is a crazy huge value since the next thing that the
ioctl would do is allocate 37GB of memory.  This is enough to make
kvmalloc mad, but isn't large enough to trip the validation functions.
In other words, I'm fussing with checks that were **already sufficient**
because that's easier than dealing with 644 internal bug reports.  Yes,
that's right, six hundred and forty-four.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1545,7 +1545,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);


