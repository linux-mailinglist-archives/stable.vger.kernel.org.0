Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13CE681092
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbjA3OEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbjA3OEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4714FEFB1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F2065CE16B6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8477C433D2;
        Mon, 30 Jan 2023 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087475;
        bh=hTS3lQSOY68LpKdHYpmHG4oaVQoUrNo+8qwtmiInaOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3Gw5c3foishmE06BOO5e7tFaoXTeZEmjWrF7o3Tg6zRk43k/Bb4EJ5raJp+mTPX4
         /StP93lLOhgfhl74t8+3b+s632UXD9eZhvXSasdj9EtBhyl9glAdPl44xmDt6EBKID
         5STANquTBmGNE/JzYXSh4+LhvZ9ZZ8sz5Ew5ZV/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+fd749a7ea127a84e0ffd@syzkaller.appspotmail.com,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 220/313] ovl: fix tmpfile leak
Date:   Mon, 30 Jan 2023 14:50:55 +0100
Message-Id: <20230130134346.956896874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit baabaa505563362b71f2637aedd7b807d270656c upstream.

Missed an error cleanup.

Reported-by: syzbot+fd749a7ea127a84e0ffd@syzkaller.appspotmail.com
Fixes: 2b1a77461f16 ("ovl: use vfs_tmpfile_open() helper")
Cc: <stable@vger.kernel.org> # v6.1
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -754,7 +754,7 @@ static int ovl_copy_up_tmpfile(struct ov
 	if (!c->metacopy && c->stat.size) {
 		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size);
 		if (err)
-			return err;
+			goto out_fput;
 	}
 
 	err = ovl_copy_up_metadata(c, temp);


