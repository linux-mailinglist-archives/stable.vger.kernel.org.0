Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B594676EB0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjAVPNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjAVPNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:13:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0042C21A2C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9095260C57
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28CDC433D2;
        Sun, 22 Jan 2023 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400393;
        bh=WYlG9v/1Zco1lVNj4ZqHfGc0viZRnzaDohWkYG4yl1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gS4v3+ppBEfRk0aTyjx6uofD7an+6TUDRIPyanC4YIapxUzlCNgtHGSnGllYKoL/c
         n9SqjikPn1kAyntI+Vo4T28zun9ZcX8v289FTIvP2Sx/vPOLGBfBphpT8P297mei0F
         XXroFmTXhHQm57eCOcmx816m0wpqxeXKZoTNj41c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Enzo Matsumiya <ematsumiya@suse.de>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 58/98] cifs: do not include page data when checking signature
Date:   Sun, 22 Jan 2023 16:04:14 +0100
Message-Id: <20230122150231.941738495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

commit 30b2b2196d6e4cc24cbec633535a2404f258ce69 upstream.

On async reads, page data is allocated before sending.  When the
response is received but it has no data to fill (e.g.
STATUS_END_OF_FILE), __calc_signature() will still include the pages in
its computation, leading to an invalid signature check.

This patch fixes this by not setting the async read smb_rqst page data
(zeroed by default) if its got_bytes is 0.

This can be reproduced/verified with xfstests generic/465.

Cc: <stable@vger.kernel.org>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3925,12 +3925,15 @@ smb2_readv_callback(struct mid_q_entry *
 				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
-				 .rq_nvec = 1,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+				 .rq_nvec = 1, };
+
+	if (rdata->got_bytes) {
+		rqst.rq_pages = rdata->pages;
+		rqst.rq_offset = rdata->page_offset;
+		rqst.rq_npages = rdata->nr_pages;
+		rqst.rq_pagesz = rdata->pagesz;
+		rqst.rq_tailsz = rdata->tailsz;
+	}
 
 	WARN_ONCE(rdata->server != mid->server,
 		  "rdata server %p != mid server %p",


