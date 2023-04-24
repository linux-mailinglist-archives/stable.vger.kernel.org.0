Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B6F6ECE57
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbjDXNbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjDXNbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395237AAB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A07C6232C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D70C433D2;
        Mon, 24 Apr 2023 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343043;
        bh=VuZK+UOIHTteeJsgKN+1MOU15lgDM1LvZKmPdVMxrrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyG3s2Uu/W4rmMIr75NIjXBxs8hj45I7k72uv4gr8OjDf0yxlBobJVnh9a6N6jH3A
         CqynU3fh5zUkzalIqwbNfAFjzCmPDXhobjVea9/EqBus2XdUGJthlSGtJAm6eIDthK
         Yv5Q2RfrwezQmdkRSUYDM4QQdJJBxDcrmdDg8xiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Mike Rapoport (IBM)" <rppt@kernel.org>,
        Zach OKeefe <zokeefe@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 055/110] Revert "userfaultfd: dont fail on unrecognized features"
Date:   Mon, 24 Apr 2023 15:17:17 +0200
Message-Id: <20230424131138.354164985@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 2ff559f31a5d50c31a3f9d849f8af90dc36c7105 upstream.

This is a proposal to revert commit 914eedcb9ba0ff53c33808.

I found this when writing a simple UFFDIO_API test to be the first unit
test in this set.  Two things breaks with the commit:

  - UFFDIO_API check was lost and missing.  According to man page, the
  kernel should reject ioctl(UFFDIO_API) if uffdio_api.api != 0xaa.  This
  check is needed if the api version will be extended in the future, or
  user app won't be able to identify which is a new kernel.

  - Feature flags checks were removed, which means UFFDIO_API with a
  feature that does not exist will also succeed.  According to the man
  page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
  unknown features passed in.

Link: https://lore.kernel.org/r/20220722201513.1624158-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20230412163922.327282-2-peterx@redhat.com
Fixes: 914eedcb9ba0 ("userfaultfd: don't fail on unrecognized features")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1966,8 +1966,10 @@ static int userfaultfd_api(struct userfa
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	/* Ignore unsupported features (userspace built against newer kernel) */
-	features = uffdio_api.features & UFFD_API_FEATURES;
+	features = uffdio_api.features;
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
 		goto err_out;


