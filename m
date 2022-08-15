Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDD9593C17
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344426AbiHOTrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345260AbiHOTqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:46:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF846DFB5;
        Mon, 15 Aug 2022 11:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2237761124;
        Mon, 15 Aug 2022 18:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2863DC433D7;
        Mon, 15 Aug 2022 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589333;
        bh=qQSA96vhbW3gjTNJAjGIG1SqfEp/08zASt479+5WVtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4K0m2FA/tqLJ0TY30BDzHs+CG3Pe6uqytR8u4RqsueuGOZVvF9HiOJjdyw4GKGSH
         zG9ZyH+Z/Z7WefWtJTLl13KDXU6qN8MiftUb8VZFDeaFaXvL3wxGr55dxSFnUn4yuh
         P2P76eWpwPChAovOhROs2inc+drLKUwyBY/G6c6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Bharath SM <bharathsm@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 685/779] SMB3: fix lease break timeout when multiple deferred close handles for the same file.
Date:   Mon, 15 Aug 2022 20:05:29 +0200
Message-Id: <20220815180406.645771646@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

commit 9e31678fb403eae0f4fe37c6374be098835c73cd upstream.

Solution is to send lease break ack immediately even in case of
deferred close handles to avoid lease break request timing out
and let deferred closed handle gets closed as scheduled.
Later patches could optimize cases where we then close some
of these handles sooner for the cases where lease break is to 'none'

Cc: stable@kernel.org
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4855,8 +4855,6 @@ void cifs_oplock_break(struct work_struc
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
-	bool is_deferred = false;
-	struct cifs_deferred_close *dclose;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4893,22 +4891,6 @@ void cifs_oplock_break(struct work_struc
 
 oplock_break_ack:
 	/*
-	 * When oplock break is received and there are no active
-	 * file handles but cached, then schedule deferred close immediately.
-	 * So, new open will not use cached handle.
-	 */
-	spin_lock(&CIFS_I(inode)->deferred_lock);
-	is_deferred = cifs_is_deferred_close(cfile, &dclose);
-	spin_unlock(&CIFS_I(inode)->deferred_lock);
-	if (is_deferred &&
-	    cfile->deferred_close_scheduled &&
-	    delayed_work_pending(&cfile->deferred)) {
-		if (cancel_delayed_work(&cfile->deferred)) {
-			_cifsFileInfo_put(cfile, false, false);
-			goto oplock_break_done;
-		}
-	}
-	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
 	 * not bother sending an oplock release if session to server still is
@@ -4919,7 +4901,7 @@ oplock_break_ack:
 							     cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
-oplock_break_done:
+
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }


