Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50E44F2C88
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiDEIm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbiDEIcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950BD9398C;
        Tue,  5 Apr 2022 01:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BBF3B81BAF;
        Tue,  5 Apr 2022 08:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A1C385A2;
        Tue,  5 Apr 2022 08:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147129;
        bh=jl6Snp2v0QTf7bMzCJgP0Dv9BzB/beZVOt0Nxq39c78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQs5mbcNLQ/ejN12DlwQUq4HvYymnLwz8ofM9ugq7xaZcJwHDMaNyPbCCx5l2Hzmp
         CEFelsStbz76IDNnyf8OrzTvFX+Y8rjgDv/15FsD9Ha3LYgmhQcKXO6iXUcVDrjW7R
         32CkYXHhEbrlFfswvUKVzUuqO1tLO8y1oUmWK4GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.17 1013/1126] ubifs: rename_whiteout: correct old_dir size computing
Date:   Tue,  5 Apr 2022 09:29:20 +0200
Message-Id: <20220405070437.222069130@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1402,6 +1402,9 @@ static int do_rename(struct inode *old_d
 			iput(whiteout);
 			goto out_release;
 		}
+
+		/* Add the old_dentry size to the old_dir size. */
+		old_sz -= CALC_DENT_SIZE(fname_len(&old_nm));
 	}
 
 	lock_4_inodes(old_dir, new_dir, new_inode, whiteout);


