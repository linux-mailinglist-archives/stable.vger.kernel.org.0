Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4D594A2D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245746AbiHOXLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353247AbiHOXLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:11:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B7779A53;
        Mon, 15 Aug 2022 13:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A13960FD8;
        Mon, 15 Aug 2022 20:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067FBC433C1;
        Mon, 15 Aug 2022 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593610;
        bh=AAVDZDfssf5k6rhB/ON9yV403YnrCocT4nm7X9rDlkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+wMK3heW7LSt0ms0Dx1HxvItVQIelDNvJRA6OTbZLxg5xBLKqv3BoILqmDxplUPS
         ma+411kd2ed4wZ85wRDjMG+kJFKz8v2Lf7L+pPDxRBkdaUjyJCGweLOyCwZbvAZsG2
         i6I/4Y7SejM/Pn2qjYuNgbJ1KJc5wa31iIdpOJXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Bharath SM <bharathsm@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 0975/1095] SMB3: fix lease break timeout when multiple deferred close handles for the same file.
Date:   Mon, 15 Aug 2022 20:06:14 +0200
Message-Id: <20220815180509.436681728@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
@@ -4807,8 +4807,6 @@ void cifs_oplock_break(struct work_struc
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
-	bool is_deferred = false;
-	struct cifs_deferred_close *dclose;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4845,22 +4843,6 @@ void cifs_oplock_break(struct work_struc
 
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
@@ -4871,7 +4853,7 @@ oplock_break_ack:
 							     cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
-oplock_break_done:
+
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }


