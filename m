Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC15A4823
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiH2LG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiH2LFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:05:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD7C642C4;
        Mon, 29 Aug 2022 04:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 287C4611BE;
        Mon, 29 Aug 2022 11:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AF4C433D6;
        Mon, 29 Aug 2022 11:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771005;
        bh=RdsxlfRGYPFDh+9Tzh7mDILcijz/JNwWIspFb79gCrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwMZQ/h8ukwP5XZ4Bico7TrRyBCBSkMPZZ5WhsMEe7i9ogHE9Ifu7tisXpLoMsQT9
         MI2onXiOHdP4noM+qMTGmfmycF5jluaga7lkbMWQx/g0h11FlFb3/vqR/kTMDkB/C9
         I1wlGoKHZ3LXqt66oZf11KhWguDR1b0hU1haFF/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 06/86] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
Date:   Mon, 29 Aug 2022 12:58:32 +0200
Message-Id: <20220829105756.791492007@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

commit 29d650f7e3ab55283b89c9f5883d0c256ce478b5 upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1689,7 +1689,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);


