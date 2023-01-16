Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE52C66C544
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjAPQER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjAPQDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:03:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF3123C6E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C457B80E5A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88C4C433D2;
        Mon, 16 Jan 2023 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884953;
        bh=vNOmU7rZkVjrdmxsBFK45aj3vDOd+UDKlEm2qmY65W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHFYGY9goB0Q8kTzRnDCh3kht4yPOWKEgKVhtfu/k73d9Yi2R3l43OlKPNFzk8B/Y
         Wh8GzIrxmKFpau4/8skEIuwxSDcu784xbhj/Jrlf9x7X8s4sA1EFNRfZm25VI5q7Ug
         S7oFhKzc5MHUdVAzFm/BFao7kRYdSftIIoLJKb88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        Tom Talpey <tom@talpey.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 19/86] cifs: Fix uninitialized memory read for smb311 posix symlink create
Date:   Mon, 16 Jan 2023 16:50:53 +0100
Message-Id: <20230116154747.894867804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Volker Lendecke <vl@samba.org>

commit a152d05ae4a71d802d50cf9177dba34e8bb09f68 upstream.

If smb311 posix is enabled, we send the intended mode for file
creation in the posix create context. Instead of using what's there on
the stack, create the mfsymlink file with 0644.

Fixes: ce558b0e17f8a ("smb3: Add posix create context for smb3.11 posix mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/link.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -459,6 +459,7 @@ smb3_create_mf_symlink(unsigned int xid,
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
+	oparms.mode = 0644;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);


