Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF44ABAB7
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384016AbiBGLY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359493AbiBGLOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:14:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C334C0401D5;
        Mon,  7 Feb 2022 03:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13D88611AA;
        Mon,  7 Feb 2022 11:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDDAC340EB;
        Mon,  7 Feb 2022 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232482;
        bh=Q9a/NR6CCkrCfIyyMhl7MJzPq8ENrfsh9TBIGOR7dsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSZ9ygbJVMwg5I5JEvBXFaqaU4R7AqmirU0n9McO6M9+wRZrjb/dbVSCIowJFFX5S
         u05V3rWQocxQAWl8HdT/bBzNVZb3sNZf+kDs+yWqGzfJTA85a83aOjlOE8e+K1EFVc
         /ObvoaaW8NN9Eottxyix5QE7Qh1evDJQx+O4Aa3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 04/86] udf: Restore i_lenAlloc when inode expansion fails
Date:   Mon,  7 Feb 2022 12:05:27 +0100
Message-Id: <20220207103757.693208252@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit ea8569194b43f0f01f0a84c689388542c7254a1f upstream.

When we fail to expand inode from inline format to a normal format, we
restore inode to contain the original inline formatting but we forgot to
set i_lenAlloc back. The mismatch between i_lenAlloc and i_size was then
causing further problems such as warnings and lost data down the line.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 7e49b6f2480c ("udf: Convert UDF to new truncate calling sequence")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -311,6 +311,7 @@ int udf_expand_file_adinicb(struct inode
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
 	put_page(page);


