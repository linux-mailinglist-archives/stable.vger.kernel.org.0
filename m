Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C1603BCC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJSIjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiJSIi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11937EFC5;
        Wed, 19 Oct 2022 01:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27581617E3;
        Wed, 19 Oct 2022 08:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B28C433C1;
        Wed, 19 Oct 2022 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168691;
        bh=7QQ5BKb8fQQrkexa28bsUpOKY8efYTmV3Cm9V0UzJ9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqU0s2n34r+5tqAjkMfyME7E0w1B6JFnDtS+P7Qpl3IS2JJQWLmXei/5niAOpgy19
         Znp/0y82JOcLlBMu8DUXZlv5i0fyM7lqRgB9Ct0FSSV7t54lkjcyOTU1lRtmu/4tap
         Bo1sOonyJxNcV/qedQyci4i0IpACa2PpOaQxGa/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 022/862] cifs: destage dirty pages before re-reading them for cache=none
Date:   Wed, 19 Oct 2022 10:21:49 +0200
Message-Id: <20221019083250.989301100@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit bb44c31cdcac107344dd2fcc3bd0504a53575c51 upstream.

This is the opposite case of kernel bugzilla 216301.
If we mmap a file using cache=none and then proceed to update the mmapped
area these updates are not reflected in a later pread() of that part of the
file.
To fix this we must first destage any dirty pages in the range before
we allow the pread() to proceed.

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
 		len = ctx->len;
 	}
 
+	if (direct) {
+		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
+						  offset, offset + len - 1);
+		if (rc) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return -EAGAIN;
+		}
+	}
+
 	/* grab a lock here due to read response handlers can access ctx */
 	mutex_lock(&ctx->aio_mutex);
 


