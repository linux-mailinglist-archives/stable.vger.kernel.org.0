Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7556FE1B
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiGKKEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiGKKDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0501B48E8F;
        Mon, 11 Jul 2022 02:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96B8961414;
        Mon, 11 Jul 2022 09:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E03AC34115;
        Mon, 11 Jul 2022 09:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531768;
        bh=dXCyeXMzsanEOjnWTi9p5QfZZN2jI9uPP4wKsJmHxbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlnXxTNFq43952O+l3WRpGCDBm8Iu7DnF9GSwDIzEdoT3zZw49N99fY+hMEgn2ZqD
         8BT+u5MUE+ynUBzKP2WJ5JPFHmpbXYuWGnVYyHEOTVSFIDMnLDBj1YvRDG6rdTBcK7
         7bUC/zbZSs/nM4atY9XnPWMkkDcueFAtZkKrhB1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 173/230] btrfs: fix error pointer dereference in btrfs_ioctl_rm_dev_v2()
Date:   Mon, 11 Jul 2022 11:07:09 +0200
Message-Id: <20220711090608.969302812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d815b3f2f273537cb8afaf5ab11a46851f6c03e5 upstream.

If memdup_user() fails the error handing will crash when it tries
to kfree() an error pointer.  Just return directly because there is
no cleanup required.

Fixes: 1a15eb724aae ("btrfs: use btrfs_get_dev_args_from_path in dev removal ioctls")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3231,10 +3231,8 @@ static long btrfs_ioctl_rm_dev_v2(struct
 		return -EPERM;
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args)) {
-		ret = PTR_ERR(vol_args);
-		goto out;
-	}
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
 	if (vol_args->flags & ~BTRFS_DEVICE_REMOVE_ARGS_MASK) {
 		ret = -EOPNOTSUPP;


