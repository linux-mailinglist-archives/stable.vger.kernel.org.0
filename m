Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43228635414
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbiKWJBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbiKWJBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:01:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFB4100B1A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:01:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 175DECE20F4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF449C433D6;
        Wed, 23 Nov 2022 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194088;
        bh=wb7GNep2kK+M2E6oiKvWSbZmw0DWJ/JAr/7OtOIrNGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ7WsMSo8UBMXfa1GrW04HQybt5V5hbRoYGUtrAgqZvZNz2/rIPGRWS2IWlKWcmuF
         ijkd0e4pnnR8rxqFG69JkejtboWz4j8EpgNziPEGKj5R3QaxMsm8cbtYb16aSn3BZW
         L4UneFoqoezwSeF/taxOp3cjgfxPIIN9Wf64L+2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.14 68/88] dm ioctl: fix misbehavior if list_versions races with module loading
Date:   Wed, 23 Nov 2022 09:51:05 +0100
Message-Id: <20221123084550.994928326@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 4fe1ec995483737f3d2a14c3fe1d8fe634972979 upstream.

__list_versions will first estimate the required space using the
"dm_target_iterate(list_version_get_needed, &needed)" call and then will
fill the space using the "dm_target_iterate(list_version_get_info,
&iter_info)" call. Each of these calls locks the targets using the
"down_read(&_lock)" and "up_read(&_lock)" calls, however between the first
and second "dm_target_iterate" there is no lock held and the target
modules can be loaded at this point, so the second "dm_target_iterate"
call may need more space than what was the first "dm_target_iterate"
returned.

The code tries to handle this overflow (see the beginning of
list_version_get_info), however this handling is incorrect.

The code sets "param->data_size = param->data_start + needed" and
"iter_info.end = (char *)vers+len" - "needed" is the size returned by the
first dm_target_iterate call; "len" is the size of the buffer allocated by
userspace.

"len" may be greater than "needed"; in this case, the code will write up
to "len" bytes into the buffer, however param->data_size is set to
"needed", so it may write data past the param->data_size value. The ioctl
interface copies only up to param->data_size into userspace, thus part of
the result will be truncated.

Fix this bug by setting "iter_info.end = (char *)vers + needed;" - this
guarantees that the second "dm_target_iterate" call will write only up to
the "needed" buffer and it will exit with "DM_BUFFER_FULL_FLAG" if it
overflows the "needed" space - in this case, userspace will allocate a
larger buffer and retry.

Note that there is also a bug in list_version_get_needed - we need to add
"strlen(tt->name) + 1" to the needed size, not "strlen(tt->name)".

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -573,7 +573,7 @@ static void list_version_get_needed(stru
     size_t *needed = needed_param;
 
     *needed += sizeof(struct dm_target_versions);
-    *needed += strlen(tt->name);
+    *needed += strlen(tt->name) + 1;
     *needed += ALIGN_MASK;
 }
 
@@ -628,7 +628,7 @@ static int list_versions(struct file *fi
 	iter_info.old_vers = NULL;
 	iter_info.vers = vers;
 	iter_info.flags = 0;
-	iter_info.end = (char *)vers+len;
+	iter_info.end = (char *)vers + needed;
 
 	/*
 	 * Now loop through filling out the names & versions.


