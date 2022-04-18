Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3513450565E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbiDRNem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244872AbiDRNa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148E91EEF1;
        Mon, 18 Apr 2022 05:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A393460FD9;
        Mon, 18 Apr 2022 12:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916F1C385A1;
        Mon, 18 Apr 2022 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286608;
        bh=RyYRvTh/gCaabpitJ9QTL82+jjl5OBhyZhWNKY8lAcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvogsyMsPle8pu55q1MgFhhZv+Niey59jG2CZhGVVvDNwEjN5/1j8DQAgb+xe5MWR
         o0n+5LzsXsi8dKaCeYEDQXzAyAfrMkzI3zINmQTNWWgjT32+NwnJz5IKlC2ErrvvBr
         Yx3NFOqgZTuQLvoQ3nK/tD41ApmnI2Owes5pnSpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.14 188/284] ubifs: rename_whiteout: correct old_dir size computing
Date:   Mon, 18 Apr 2022 14:12:49 +0200
Message-Id: <20220418121217.081930940@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1452,6 +1452,9 @@ static int do_rename(struct inode *old_d
 			if (unlink)
 				drop_nlink(old_dir);
 		}
+
+		/* Add the old_dentry size to the old_dir size. */
+		old_sz -= CALC_DENT_SIZE(fname_len(&old_nm));
 	}
 
 	old_dir->i_size -= old_sz;


