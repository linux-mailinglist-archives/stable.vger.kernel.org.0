Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A2E6DEEE7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjDLIqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDLIqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0EC86AE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC62630E9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E27DC4339B;
        Wed, 12 Apr 2023 08:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289112;
        bh=nRtfYNe4WbQkl0xaaX7/+XdjN/OF22kpnRePfMNS8XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XF4ROMn5h7uvmkJj5s7th9s8TzDbz9BfhPxj87phoAfqQ9QpRlDKSW7ZPFgrwUgtH
         0BVpr2QRo9Ro37m2KlDY/SQ2uLTuI/efGXpy9DB5blx0updYPe/1Sxn249/IdY6OSv
         qSG7yOzhVaHTboTrMmJPGsLjxsxSq1Vq2szZn+e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 113/164] fs: drop peer group ids under namespace lock
Date:   Wed, 12 Apr 2023 10:33:55 +0200
Message-Id: <20230412082841.416917739@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit cb2239c198ad9fbd5aced22cf93e45562da781eb upstream.

When cleaning up peer group ids in the failure path we need to make sure
to hold on to the namespace lock. Otherwise another thread might just
turn the mount from a shared into a non-shared mount concurrently.

Link: https://lore.kernel.org/lkml/00000000000088694505f8132d77@google.com
Fixes: 2a1867219c7b ("fs: add mount_setattr()")
Reported-by: syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # 5.12+
Message-Id: <20230330-vfs-mount_setattr-propagation-fix-v1-1-37548d91533b@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4180,9 +4180,9 @@ out:
 	unlock_mount_hash();
 
 	if (kattr->propagation) {
-		namespace_unlock();
 		if (err)
 			cleanup_group_ids(mnt, NULL);
+		namespace_unlock();
 	}
 
 	return err;


