Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07ADE505664
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbiDRNeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244880AbiDRNbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8D32A5;
        Mon, 18 Apr 2022 05:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D11612BB;
        Mon, 18 Apr 2022 12:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B388C385A9;
        Mon, 18 Apr 2022 12:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286617;
        bh=ASvl4kzOlN2JBFPVcDkp6qC7onoQI+kOPopbQo3QmCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQX+TmUTToZ5sfVUS/vL60b8Cc2mKayvZkYWw+xqjnbTuzIUCR7QtGJ8EKmW3L8HS
         ZV4r7DgDsGmGWxfS74DiviQRznIV3rWgL8Ng0x5X0qLmtx3Nr6ERHCykg8o7Ix03J3
         RFPOvV0C6EWXCCq2zYFjJmCa6QCURv7zKaL/fgxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Price <anprice@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4.14 191/284] gfs2: Make sure FITRIM minlen is rounded up to fs block size
Date:   Mon, 18 Apr 2022 14:12:52 +0200
Message-Id: <20220418121217.165187102@linuxfoundation.org>
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

From: Andrew Price <anprice@redhat.com>

commit 27ca8273fda398638ca994a207323a85b6d81190 upstream.

Per fstrim(8) we must round up the minlen argument to the fs block size.
The current calculation doesn't take into account devices that have a
discard granularity and requested minlen less than 1 fs block, so the
value can get shifted away to zero in the translation to fs blocks.

The zero minlen passed to gfs2_rgrp_send_discards() then allows
sb_issue_discard() to be called with nr_sects == 0 which returns -EINVAL
and results in gfs2_rgrp_send_discards() returning -EIO.

Make sure minlen is never < 1 fs block by taking the max of the
requested minlen and the fs block size before comparing to the device's
discard granularity and shifting to fs blocks.

Fixes: 076f0faa764ab ("GFS2: Fix FITRIM argument handling")
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/rgrp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1380,7 +1380,8 @@ int gfs2_fitrim(struct file *filp, void
 
 	start = r.start >> bs_shift;
 	end = start + (r.len >> bs_shift);
-	minlen = max_t(u64, r.minlen,
+	minlen = max_t(u64, r.minlen, sdp->sd_sb.sb_bsize);
+	minlen = max_t(u64, minlen,
 		       q->limits.discard_granularity) >> bs_shift;
 
 	if (end <= start || minlen > sdp->sd_max_rg_data)


