Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD1C5013C7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245609AbiDNODP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346133AbiDNNzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA2E37BC2;
        Thu, 14 Apr 2022 06:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C85C2B82968;
        Thu, 14 Apr 2022 13:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF53C385A1;
        Thu, 14 Apr 2022 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943942;
        bh=HRQ3C+aQCRnR3x8Nz9w8SDlrdrti2/nJi7eqYKqPTBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJTSwk5RR+i816ASKUcwHs5TZbZyREnMLb+UENaFzCPdzZXZcyghpcwaK6Zm1w4RX
         FhBalVE/CUj1Ub7Z6dQGk9foqCXbqlVnTZu76LYrm7QdhHXHbVEb0wmfzSbu+QWENL
         hj151PAqncRo1KFgIaj+HQiQCcET9OClV+6vAKQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 336/475] ubifs: rename_whiteout: correct old_dir size computing
Date:   Thu, 14 Apr 2022 15:12:01 +0200
Message-Id: <20220414110904.487649716@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Baokun Li <libaokun1@huawei.com>

commit 705757274599e2e064dd3054aabc74e8af31a095 upstream.

When renaming the whiteout file, the old whiteout file is not deleted.
Therefore, we add the old dentry size to the old dir like XFS.
Otherwise, an error may be reported due to `fscki->calc_sz != fscki->size`
in check_indes.

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1368,6 +1368,9 @@ static int do_rename(struct inode *old_d
 			iput(whiteout);
 			goto out_release;
 		}
+
+		/* Add the old_dentry size to the old_dir size. */
+		old_sz -= CALC_DENT_SIZE(fname_len(&old_nm));
 	}
 
 	lock_4_inodes(old_dir, new_dir, new_inode, whiteout);


