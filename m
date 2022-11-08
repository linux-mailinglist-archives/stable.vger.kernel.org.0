Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5299C621590
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiKHONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbiKHONC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AE757B43
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 450A9CE1B76
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB01C433D6;
        Tue,  8 Nov 2022 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916778;
        bh=UUp/1dCVOgRocXdqFeBIj8Rec8yroF2G1c9WjgzZUfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMRgpmaAvuTXSIHpny/4ZbXQeC0oTBaxN4HzZeoqbCGIcxgC9igNuiPEi6CyyQ0df
         TZ6k8yYBH+oRUENDUO/4aFMc7UHZpIPImh5002JiJsISFNwZ6q03ddeflU+9tsiGMC
         3DVY6QAlL1zn+P/obMtSZcHV3jVnoywEBr30H7Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nikolay Borisov <nborisov@suse.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 131/197] btrfs: fix a memory allocation failure test in btrfs_submit_direct
Date:   Tue,  8 Nov 2022 14:39:29 +0100
Message-Id: <20221108133400.924752280@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 063b1f21cc9be07291a1f5e227436f353c6d1695 upstream.

After allocation 'dip' is tested instead of 'dip->csums'.  Fix it.

Fixes: 642c5d34da53 ("btrfs: allocate the btrfs_dio_private as part of the iomap dio bio")
CC: stable@vger.kernel.org # 5.19+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8142,7 +8142,7 @@ static void btrfs_submit_direct(const st
 		 */
 		status = BLK_STS_RESOURCE;
 		dip->csums = kcalloc(nr_sectors, fs_info->csum_size, GFP_NOFS);
-		if (!dip)
+		if (!dip->csums)
 			goto out_err;
 
 		status = btrfs_lookup_bio_sums(inode, dio_bio, dip->csums);


