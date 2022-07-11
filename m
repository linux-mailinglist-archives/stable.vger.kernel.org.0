Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3DF56FDCB
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiGKKAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiGKJ7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FE5B7D49;
        Mon, 11 Jul 2022 02:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A029B80D2C;
        Mon, 11 Jul 2022 09:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3C3C34115;
        Mon, 11 Jul 2022 09:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531679;
        bh=qXisc+E/ALompKboJG36VZK8MAarwbjXLP9t9pP4C+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWqQemC2DusARXLkvp2AiTqJCfuX0TMfIES6+V1ImDaEfIj4yZtaichRJ/UdnfNye
         vtTUwtLV8tYt3ydanwvtcDZajltl6rDd4DBlht8yyU9JSBKGVXEyxljuTuz2VZmjh1
         Jz31rjFBW26LPONmXd5OdkcZblR7KC5GYTmI+b1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Tom Rix <trix@redhat.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 175/230] btrfs: fix use of uninitialized variable at rm device ioctl
Date:   Mon, 11 Jul 2022 11:07:11 +0200
Message-Id: <20220711090609.025325347@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 37b4599547e324589e011c20f74b021d6d25cb7f upstream.

Clang static analysis reports this problem
ioctl.c:3333:8: warning: 3rd function call argument is an
  uninitialized value
    ret = exclop_start_or_cancel_reloc(fs_info,

cancel is only set in one branch of an if-check and is always used.  So
initialize to false.

Fixes: 1a15eb724aae ("btrfs: use btrfs_get_dev_args_from_path in dev removal ioctls")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3291,7 +3291,7 @@ static long btrfs_ioctl_rm_dev(struct fi
 	struct block_device *bdev = NULL;
 	fmode_t mode;
 	int ret;
-	bool cancel;
+	bool cancel = false;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;


