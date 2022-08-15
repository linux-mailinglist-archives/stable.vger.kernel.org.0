Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32960594DC5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbiHPAy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiHPAwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:52:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B282319C356;
        Mon, 15 Aug 2022 13:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0120B8119A;
        Mon, 15 Aug 2022 20:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10734C433B5;
        Mon, 15 Aug 2022 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596452;
        bh=sWzJWFXZ47BjizJQtMctDjaB0kYZ1UpVWzqFfS37h4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ziu5HJdBqfEq6WbrfByvmcejl7hv/LbvwL8pJnAjHyR8UXvem6HTLdm8999g7GXJ7
         n6zlTuZrHN4h8vPqLetBFIQfnvVK/6SIRcbBEr+6ORW95cjfAEHLCQ6Fty4pKlj5u2
         fAUKrTMVZGKZaTfDRKWJAedeiwe29+pFkUbnjhRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Bharath SM <bharathsm@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 1050/1157] SMB3: fix lease break timeout when multiple deferred close handles for the same file.
Date:   Mon, 15 Aug 2022 20:06:46 +0200
Message-Id: <20220815180522.060902953@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
@@ -4811,8 +4811,6 @@ void cifs_oplock_break(struct work_struc
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
-	bool is_deferred = false;
-	struct cifs_deferred_close *dclose;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4849,22 +4847,6 @@ void cifs_oplock_break(struct work_struc
 
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
@@ -4875,7 +4857,7 @@ oplock_break_ack:
 							     cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
-oplock_break_done:
+
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }


